require "spec_helper"

describe Invoice do
  describe "after save and reinitializing" do
    before do
      @invoice = Invoice.create!(
        oid: "r@nd0m1d000",
        otype: "Invoice__c",
        data: {
          "Id"=>"r@nd0m1d111",
          "IsDeleted"=>false,
          "Name"=>"INV-0000"
        },
        last_modified: "2014-01-19 07:48:35",
        last_checked: "2014-01-19 07:48:35"
      )

      @line_item = Ply.create!(
        oid: "a01i0000007kDbrAAE",
        otype: "Line_Item__c",
        data: {
          "Id"=>"a01i0000007kDbrAAE",
          "IsDeleted"=>false,
          "Name"=>"i"
        },
        last_modified: "2014-01-19 07:48:36",
        last_checked: "2014-01-19 07:48:36"
      )

      @ply_relation = PlyRelation.create!(
        child_id: @line_item.id,
        child_type: @line_item.otype,
        parent_id: @invoice.id,
        parent_type: @invoice.otype
      )
    end

    it "should have all kinds of AR jazz" do
      @invoice = Invoice.first
      @invoice.line_items.first.id == @line_item.id
      Invoice.all.should === [@invoice]
      Invoice.where(last_modified: "2014-01-19 07:48:35").should eq [@invoice]
      Invoice.first.should eq @invoice
      Ply.all.count.should be > Invoice.all.count
      LineItem.first.should_not eq Invoice.first
      @invoice.line_items.first.class.name.should eq "LineItem"
    end
  end
end
