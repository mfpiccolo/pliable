pliable
============
| Project                 |  Gem Release      |
|------------------------ | ----------------- |
| Gem name                |  pliable      |
| License                 |  [MIT](LICENSE.txt)   |
| Version                 |  [![Gem Version](https://badge.fury.io/rb/pliable.png)](http://badge.fury.io/rb/pliable) |
| Continuous Integration  |  [![Build Status](https://travis-ci.org/mfpiccolo/pliable.png?branch=master)](https://travis-ci.org/mfpiccolo/pliable)
| Grade                   |  [![Code Climate](https://codeclimate.com/github/mfpiccolo/pliable.png)](https://codeclimate.com/github/mfpiccolo/pliable)
| Homepage                |  [http://mfpiccolo.github.io/pliable][homepage] |
| Documentation           |  [http://rdoc.info/github/mfpiccolo/pliable/frames][documentation] |
| Issues                  |  [https://github.com/mfpiccolo/pliable/issues][issues] |

## Description

Pliable makes integrating a Rails project with Schemaless data not so painful.

Rolling your own integration with an external service where the schema can change from moment to moment can be tough.  Pliable makes it a bit easier by giving you a familiar place to store this data (models backed by postgres) and familiar ways of interacting with it (Active Record objects, complete with associations).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "pliable"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pliable

## Features

Pliable allows you to save individual records from external schemaless databases into your postgres
backed rails apps.  We store all of the data in a plies table.  The Ply model contains logic that allows
you to inherit from Ply and then act as if these iherited models are normal Active Record models.

Here is the Ply model your generator created:

```ruby
class Ply < Pliable::Ply
  # Define methods here that you want all you Ply backed models to have.
end
```

Now you can create a model that is backed by Ply.

```ruby
class Foo < Ply
  # This is redundant if it is the same name ass the class but required for now.
  ply_name "Foo"
  # Define methods that you only want Foo to have.
end
```

Now lets make another Ply Backed Model.

```ruby
class Bar < Ply
  ply_name "Bar"
end
```

Now you should be able to treat these like any other Active Record object with the added bonus of a
few features.  You can assign any json data to the data attribute.

```ruby
foo = Foo.create(data: {"some" => "json", "other" => "data"})
```
The nice part is now these json keys are methods.
```ruby
foo.some => "json"
```

Another nicety is associations.  You can associate a Ply inhereted class to another using parent
and child relationships and the PlyRelations model
```ruby
foo = Foo.create
bar = Bar.create
PlyRealation.create(parent_id: foo.id, parent_type: foo.class.name, child_id: bar, child_type: bar.class.name)

foo.bars => <#<ActiveRecord::AssociationRelation [#<Pliable::Ply id: 2 otype: "Bar" ...>
```

## Configuration

To use the generator run:

    $ rails g pliable:model

This will set up pliable.rb initializer, create the migration and run it and add a Ply model and specs.

In the initializer, specify any aditional logic you need to prepare the ply_name for pluralization.

```ruby
Pliable.configure do |config|
  # Add logic to this bloc to change the names given by external services so we can pluralize.
  # For instance if you ply names need to gsub __c of the end do:
  config.added_scrubber {|name| name.gsub('__c', '') }
end
```

## Examples

An example of a salesforce integration:

Here is your Ply model:

```ruby
# Notice it inherits from Pliable::Ply
class Ply < Pliable::Ply

  # Define methods here that you want all of your models to have
  def anything_you_like
    puts "I can play disco all night"
  end

end
```

This is an example salesforce Invoice model:

```ruby
# Notice it inherits from your apps Ply
class Invoice < Ply

  # If you dont put this you will get all Ply records.
  # This is the name that you have put into the otype attribute.
  # In this example I just used the exact salesforce api name
  ply_name "Invoice__c"

  # Add Invoice specific methods here
  def what_dosnt_gather_moss?
    "A rolling stone!"
  end

end
```

Here is an example associated salesforce model:

```ruby
class LineItem < Ply

  ply_name "Line_Item__c"

  # You guessed it.  LineItem specific methods here.
  def best_pliable_quote
    "Facts are stubborn, but statistics are more pliable. - Mark Twain"
  end

end
```

Here is your PlyRelation model:

```ruby
# This will probably not be needed in the future and will live in the gem
class PlyRelation < ActiveRecord::Base
  belongs_to :parent, class_name: 'Ply'
  belongs_to :child, class_name: 'Ply'
end
```

A service object for pulling salesforce data into your app:

```ruby
class SalesforceSynch

  attr_reader :user, :client

  def initialize(user)
    @user = user
  end

  def call
    set_clients  # Connect to your Salesforce data (i.e. databsedotcom or restforce)
    create_plys_from_salesforce_records # Create records in your PG database using Ply model
    create_ply_relations # Dynamically create associations based on the data recieved
  end

  def self.call
    new.call
  end

  def set_clients
    #Fake service object that sets up a client to connect to databasedotcom
    @client = ConnectToDatabasedotcom.call(user.salesforce_credentials)
  end

  def create_plys_from_salesforce_records
    data = []

    # sf_api model names as strings in array
    records = []

    # User has_many :plies in this example (i.e. user.plies)
    client.get_the_records_you_want.each do |record|
      object = user.plies.find_or_create_by(oid: record.Id)
      object.update_attributes(
        # The data attribute is a json column.  This is where you store all shcemaless data.
        data: record.attributes,
        # Whatever the service calls the object (i.e. Invoice__c for salesforce)
        otype: record.salesforce_api_name,
        # Use last_checked and last_modified to know when you need to update a record
        last_checked: Time.zone.now
      )
    end
  end

  # Dynamically deduce if there is a relationship with any of the plys that have been imported.
  # In the case of saleforce the id of related object is stored by using the name of that
  # object as a key. (ie "Invoice__c" => "long_uiniq_id").  In this app users choose a few models
  # that they want to bring over but you could easily just get everything.
    user.plies.each do |ply|
      related_model_names = ply.instance_variables.map {|e| e.to_s.gsub("@", "") } & user.model_names
      related_model_names.each do |name|
        child = Ply.find_by_oid(ply.send(name.to_sym))
        unless PlyRelation.where(parent_id: record.id, child_id: child.id).present?
          ply.children.new(
            parent_id: ply.id,
            parent_type: ply.otype,
            child_id: ply.id,
            child_type: ply.otype
            ).save # #create does not work yet.  Sorry
        end
      end
    end
  end
end
```

Now with this setup you can run something like this

```ruby
SalesforceSynch.call(@user)  # Awesome.  You just imported all your salesforce data.

invoice = Invoice.first => #<Invoice id: 1, user_id: 1, oid: "randomnumber", otype: "Invoice__c",
# data: {"Id"=>"a00i000000BbWLvAAN", "OwnerId"=>"005i0000002NdyWAAS", "Owner"=>nil...}...>

invoice.line_items => #<ActiveRecord::AssociationRelation [#<Pliable::Ply id: 2 ...>

invoice.line_items.first.invoices.find(invoice.id) === invoice => true

invoice.SalesForceCustomAttribute__c => Whatever it is in salesforce.

Invoice.all => #<ActiveRecord::Relation [#<Invoice id: 136, user_id: 1...>

LineItem.first => #<LineItem id: 145, user_id: 1...>

Invoice.find_by_oid("random_oid_number") => #<Invoice id: 132, user_id: 1, oid: "rand...">

# All the normal active-recordy goodness
```

## Requirements

## Donating
Support this project and [others by mfpiccolo][gittip-mfpiccolo] via [gittip][gittip-mfpiccolo].

[gittip-mfpiccolo]: https://www.gittip.com/mfpiccolo/

## Copyright

Copyright (c) 2013 Mike Piccolo

See [LICENSE.txt](LICENSE.txt) for details.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/pliable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/3d22924e211bdc891d3ad124e085a595 "githalytics.com")](http://githalytics.com/mfpiccolo/pliable)

[license]: https://github.com/mfpiccolo/pliable/MIT-LICENSE
[homepage]: http://mfpiccolo.github.io/pliable
[documentation]: http://rdoc.info/github/mfpiccolo/pliable/frames
[issues]: https://github.com/mfpiccolo/pliable/issues

