require "spec_helper"

describe PlyRelation do
  before do
    @ply_relation = PlyRelation.new
  end

  it "must be valid" do
    @ply_relation.save.should be_true
    @ply_relation.reload.should be_true
  end
end
