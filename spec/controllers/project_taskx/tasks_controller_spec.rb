require 'spec_helper'

module ProjectTaskx
  describe TasksController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
           
    end
    
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      @project_num_time_gen = FactoryGirl.create(:engine_config, :engine_name => 'heavy_machinery_projectx', :engine_version => nil, :argument_name => 'project_num_time_gen', :argument_value => ' HeavyMachineryProjectx::Project.last.nil? ? (Time.now.strftime("%Y%m%d") + "-"  + 112233.to_s + "-" + rand(100..999).to_s) :  (Time.now.strftime("%Y%m%d") + "-"  + (HeavyMachineryProjectx::Project.last.project_num.split("-")[-2].to_i + 555).to_s + "-" + rand(100..999).to_s)')
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @task_sta = FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'task_status')
      @cust = FactoryGirl.create(:kustomerx_customer) 
      @proj = FactoryGirl.create(:heavy_machinery_projectx_project, :customer_id => @cust.id) 
    end
    
    render_views
    
    describe "GET 'index'" do
      it "returns tasks" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'project_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProjectTaskx::Task.where(:cancelled => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:project_taskx_task, :project_id => @proj.id)
        task1 = FactoryGirl.create(:project_taskx_task, :project_id => @proj.id, :name => 'a new task')
        get 'index', {:use_route => :project_taskx}
        assigns[:tasks].should =~ [task, task1]
      end
      
      it "should only return the task for a project_id" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'project_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProjectTaskx::Task.where(:cancelled => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:project_taskx_task, :project_id => @proj.id)
        task1 = FactoryGirl.create(:project_taskx_task, :project_id => @proj.id + 1, :name => 'a new task')
        get 'index', {:use_route => :project_taskx, :project_id => @proj.id}
        assigns[:tasks].should =~ [task]
      end
      
      it "should only return the task for the project_id" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'project_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProjectTaskx::Task.where(:cancelled => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:project_taskx_task, :project_id => @proj.id, :cancelled => true)
        task1 = FactoryGirl.create(:project_taskx_task, :project_id => @proj.id, :name => 'a new task')
        get 'index', {:use_route => :project_taskx, :project_id => @proj.id}
        assigns[:tasks].should =~ [task1]
      end
      
      
      it "should return the task for the task_category" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'project_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProjectTaskx::Task.where(:cancelled => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:project_taskx_task, :project_id => @proj.id, :task_category => 'production')
        task1 = FactoryGirl.create(:project_taskx_task, :project_id => @proj.id,  :name => 'a new task')
        get 'index', {:use_route => :project_taskx, :task_category => 'production'}
        assigns[:tasks].should =~ [task]
      end
      
      
    end
  
    describe "GET 'new'" do
      it "returns bring up new page with task_category" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'project_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:use_route => :project_taskx, :task_category => 'production', :project_id => @proj.id}
        response.should be_success
        assigns[:task_category].should eq('production')
      end
      
      it "should bring up new page without task_category" do        
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'project_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:use_route => :project_taskx, :project_id => @proj.id}
        response.should be_success
         
      end
    end
  
    describe "GET 'create'" do
      it "should create and redirect after successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'project_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.attributes_for(:project_taskx_task, :project_id => @proj.id )  
        get 'create', {:use_route => :project_taskx, :task => task, :project_id => @proj.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do        
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'project_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.attributes_for(:project_taskx_task, :project_id => @proj.id, :name => nil)
        get 'create', {:use_route => :project_taskx, :task => task}
        response.should render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns edit page" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'project_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:project_taskx_task, :project_id => @proj.id, :task_category => 'production')
        get 'edit', {:use_route => :project_taskx, :id => task.id}
        response.should be_success
      end
    end
  
    describe "GET 'update'" do
      it "should return success and redirect" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'project_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:project_taskx_task, :project_id => @proj.id, :task_category => 'production')
        get 'update', {:use_route => :project_taskx, :id => task.id, :task => {:name => 'new name'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'project_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:project_taskx_task, :project_id => @proj.id, :task_category => 'production')
        get 'update', {:use_route => :project_taskx, :id => task.id, :task => {:name => ''}}
        response.should render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'project_taskx_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.executioner_id == session[:user_id]")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:project_taskx_task, :project_id => @proj.id, :task_category => 'production', :executioner_id => @u.id)
        get 'show', {:use_route => :project_taskx, :id => task.id}
        response.should be_success
      end
    end
  
  end
end
