module ProjectTaskx
  class Task < ActiveRecord::Base
    attr_accessor :task_status_noupdate, :executioner_noupdate, :requested_by_noupdate, :cancelled_noupdate, :completed_noupdate
    
    attr_accessible :cancelled, :completed, :executioner_id, :finish_date, :instruction, :last_updated_by_id, :name, :project_id, :requested_by_id, 
                    :requirement, :start_date, :status_id, :task_category,
                    :as => :role_new
    
    attr_accessible :cancelled, :completed, :executioner_id, :finish_date, :instruction, :last_updated_by_id, :name, :project_id, :requested_by_id, 
                    :requirement, :start_date, :status_id, :task_category,
                    :task_status_noupdate, :executioner_noupdate, :requested_by_noupdate, :cancelled_noupdate, :completed_noupdate,
                    :as => :role_update
                    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :project, :class_name => ProjectTaskx.project_class.to_s
    belongs_to :requested_by, :class_name => 'Authentify::User'
    belongs_to :executioner, :class_name => 'Authentify::User'
    belongs_to :status, :class_name => 'Commonx::MiscDefinition' 
    
    validates :name, :presence => true,
                     :uniqueness => {:scope => :project_id, :case_sensitive => false} 
    validates :project_id, :status_id, :presence => true,
                           :numericality => {:greater_than => 0}
    validates_presence_of :start_date
  end
end
