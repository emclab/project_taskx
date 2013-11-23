require 'spec_helper'

module ProjectTaskx
  describe Task do
    it "should be OK" do
      c = FactoryGirl.build(:project_taskx_task)
      c.should be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:project_taskx_task, :name => nil)
      c.should_not be_valid
    end
    
    it "should reject dup name" do
      c = FactoryGirl.create(:project_taskx_task, :name => "nil")
      c1 = FactoryGirl.build(:project_taskx_task, :name => "Nil", :project_id => c.project_id)
      c1.should_not be_valid
    end
    
    it "should reject nil project_id" do
      c = FactoryGirl.build(:project_taskx_task, :project_id => nil)
      c.should_not be_valid
    end
    
    it "should reject nil status_id" do
      c = FactoryGirl.build(:project_taskx_task, :status_id => nil)
      c.should_not be_valid
    end
    
    it "should reject nil start_date" do
      c = FactoryGirl.build(:project_taskx_task, :start_date => nil)
      c.should_not be_valid
    end
  end
end
