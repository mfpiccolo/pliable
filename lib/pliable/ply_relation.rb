class PlyRelation < ActiveRecord::Base
  belongs_to :parent, class_name: 'Ply'
  belongs_to :child, class_name: 'Ply'
end
