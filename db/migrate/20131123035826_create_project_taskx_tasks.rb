class CreateProjectTaskxTasks < ActiveRecord::Migration
  def change
    create_table :project_taskx_tasks do |t|
      t.integer :project_id
      t.string :task_category
      t.string :name
      t.text :instruction
      t.text :requirement
      t.integer :status_id
      t.date :start_date
      t.date :finish_date
      t.boolean :cancelled, :default => false
      t.boolean :completed, :default => false
      t.integer :last_updated_by_id
      t.integer :requested_by_id
      t.integer :executioner_id

      t.timestamps
    end
    
    add_index :project_taskx_tasks, :project_id
    add_index :project_taskx_tasks, :task_category
    add_index :project_taskx_tasks, :cancelled
    add_index :project_taskx_tasks, :completed
    add_index :project_taskx_tasks, :name
    add_index :project_taskx_tasks, :status_id
  end
end
