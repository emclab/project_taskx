# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_taskx_task, :class => 'ProjectTaskx::Task' do
    project_id 1
    task_category "My cate String"
    name "My name String"
    instruction "My Text"
    requirement "MyText"
    status_id 1
    start_date "2013-11-22"
    finish_date "2013-11-22"
    cancelled false
    completed false
    last_updated_by_id 1
    requested_by_id 1
    executioner_id 1
  end
end
