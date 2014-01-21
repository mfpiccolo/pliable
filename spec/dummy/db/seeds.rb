require 'csv'    
Varietal.delete_all
VarietalAlias.delete_all
if Varietal.count == 0
  CSV.foreach('db/static/varietals.csv', :headers => true) do |row|
    Varietal.create!(row.to_hash)
  end
  CSV.foreach('db/static/varietal_aliases.csv', :headers => true) do |row|
    VarietalAlias.create!(row.to_hash)
  end
end
Bottle.delete_all # for now
if Bottle.count == 0
  CSV.foreach('db/static/bottles.csv', :headers => true) do |row|
    Bottle.create!(row.to_hash)
  end
end
