require "project_taskx/engine"

module ProjectTaskx
  mattr_accessor :project_class, :show_project_path
  
  def self.project_class
    @@project_class.constantize
  end
end
