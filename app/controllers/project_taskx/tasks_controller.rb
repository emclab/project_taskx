require_dependency "project_taskx/application_controller"

module ProjectTaskx
  class TasksController < ApplicationController
    before_filter :require_employee
    before_filter :load_parent_record
        
    def index
      @title = t('Event Tasks')
      @tasks = params[:project_taskx_tasks][:model_ar_r]  #returned by check_access_right
      @tasks = @tasks.where(:project_id => @project.id) if @project 
      @tasks = @tasks.where('TRIM(project_taskx_tasks.task_category) = ?', params[:task_category].strip) if params[:task_category].present?
      @tasks = @tasks.page(params[:page]).per_page(@max_pagination) 
      @erb_code = find_config_const('task_index_view', 'project_taskx')
    end
  
    def new
      @title = t('New Event Task')
      @task = ProjectTaskx::Task.new()
      @task_category = params[:task_category].strip if params[:task_category].present?
      @erb_code = find_config_const('task_new_view', 'project_taskx')
    end
  
    def create
      @task = ProjectTaskx::Task.new(params[:task], :as => :role_new)
      @task.last_updated_by_id = session[:user_id]
      @task.requested_by_id = session[:user_id]
      if @task.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @project = ProjectTaskx.project_class.find_by_id(params[:task][:project_id]) if params[:task].present? && params[:task][:project_id].present?
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Event Task')
      @task = ProjectTaskx::Task.find_by_id(params[:id])
      @erb_code = find_config_const('task_edit_view', 'project_taskx')
    end
  
    def update
      @task = ProjectTaskx::Task.find_by_id(params[:id])
      @task.last_updated_by_id = session[:user_id]
      if @task.update_attributes(params[:task], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Show Event Task')
      @task = ProjectTaskx::Task.find_by_id(params[:id])
      @erb_code = find_config_const('task_show_view', 'project_taskx')
    end
    
    protected
    def load_parent_record
      @project = ProjectTaskx.project_class.find_by_id(params[:project_id]) if params[:project_id].present?
      @project = ProjectTaskx.project_class.find_by_id(ProjectTaskx::Task.find_by_id(params[:id]).project_id) if params[:id].present?
    end
  end
end
