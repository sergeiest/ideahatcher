class CampaignsController < ApplicationController
  # GET /campaigns
  # GET /campaigns.json

  layout "campaigns"

  before_filter do
    wrong_link = 0
    if session[:id] == nil || session[:id] == 0
      if !params[:login].nil?
        wrong_link = 2 #access from home page
      else
        wrong_link = 1
      end
    else
      case params[:action]
        when "create_step"
          user = User.find(session[:id])
          if user.nil?
            wrong_link = 1
          else
            if params[:id].nil? || Owner.where("startup_id = ? AND user_id = ?", params[:id], session[:id]).length == 0
              params[:id] = nil
            end
          end
        when "about_step", "description_step", "upload_logo", "publish_step", "circles_step",
            "update_description", "update_name"
          user = User.find(session[:id])
          if user.nil? || Owner.where("startup_id = ? AND user_id = ?", params[:id], session[:id]).length == 0
            wrong_link = 1
          end
        when "guide_step", "basic_step", "next_step"
        else
          wrong_link = 1
      end
    end
    case wrong_link
      when 1
        redirect_to :controller => 'authentications', :action => 'wrong_link'
      when 2
        render "authentications/join_login_form" and return
    end
  end

  def guide_step

  end

  def next_step
    redirect_to  :action =>'basic_step'
  end

  def basic_step
     @startup = Startup.new
  end

  def create_step

    if params[:id] == nil
      params[:startup][:status] = 0
      @startup = Startup.new(params[:startup])
    else
      @startup = Startup.find(params[:id])
    end

    startup_errors = Startup.check_errors(params[:startup])

    if startup_errors != nil
      @startup.errors.add startup_errors.partition("/")[0]  , startup_errors.partition("/")[2]
      respond_to  do |format|
        format.html { render action: "basic_step" }
        format.json { render json: @startup }
      end
    else
      if params[:id] == nil
        respond_to do |format|
          if @startup.save
            owner = Owner.new
            owner.startup_id = @startup.id
            owner.user_id = session[:id]
            owner.status = 1
            owner.save
            format.html { redirect_to action: 'about_step', :id => @startup.id}
          else
            format.html { render action: "basic_step"}
          end
        end
      else
        respond_to do |format|
          if @startup.update_attributes(params[:startup])
            format.html { redirect_to action: 'about_step', :id => @startup.id}
          else
            format.html { render action: "basic_step"}
          end
        end
      end
    end


  end

  def about_step

    @startup = Startup.find(params[:id])
    all_descriptions = @startup.Companydescriptions.where("status = 1")
    @descriptions = Array.new

    Allfield.where("view_flag = 3").each do |all_field|
      if all_descriptions.select{|x| x.allfield_id == all_field.id}.length > 0
        @descriptions << all_descriptions.select{|x| x.allfield_id == all_field.id}[0]
      else
        new_description = Companydescription.new
        new_description.allfield_id = all_field.id
        new_description.field_status = all_field.field_name
        @descriptions << new_description
      end
    end

    @descriptions.sort!{|x, y| x["allfield_id"] <=> y["allfield_id"]}

  end

  def description_step

    #Works only for 3 fields!

    startup = Startup.find(params[:id])
    all_descriptions = startup.Companydescriptions.where("status = 1")
    no_errors = 1

    params_descriptions = Array.new

    params_description = Companydescription.new
    params_description.allfield_id = params[:companydescriptions1][:allfield_id]
    params_description.content = params[:companydescriptions1][:content]
    params_description.field_status = params[:companydescriptions1][:field_status]
    params_descriptions << params_description

    params_description = Companydescription.new
    params_description.allfield_id = params[:companydescriptions2][:allfield_id]
    params_description.content = params[:companydescriptions2][:content]
    params_description.field_status = params[:companydescriptions2][:field_status]
    params_descriptions << params_description

    params_description = Companydescription.new
    params_description.allfield_id = params[:companydescriptions3][:allfield_id]
    params_description.content = params[:companydescriptions3][:content]
    params_description.field_status = params[:companydescriptions3][:field_status]
    params_descriptions << params_description

    params_descriptions.each do |params_description|
      descriptions = all_descriptions.select {|a| a.allfield_id == params_description.allfield_id }
      i = 0
      description_id = nil
      descriptions.each do |description|
        if description.content != params_description.content
          description.update_attributes :status => 0
          description_id = description.id
        else
          description.update_attributes :status => 0 if i == 1
          i = 1
        end
      end
      if i == 0
        description = Companydescription.new
        description.allfield_id = params_description.allfield_id
        description.content = params_description.content
        description.field_status = params_description.field_status
        description.startup_id = params[:id]
        description.status = 1
        description.companydescription_id = description_id
        no_errors = 0 if !description.save
      end
    end

    respond_to do |format|
      if no_errors == 1
        startup.update_attributes :status => 1
        format.html { redirect_to action: 'circles_step', :id => startup.id}
      else
        format.html { render action: 'about_step'}
      end
    end


  end

  def circles_step
    @startup = Startup.find(params[:id])
    @tags = @startup.Tags
    @people = User.all[0..5]
    @circles = User.all[0..9]
  end

  def publish_step
    startup = Startup.find(params[:id])
    startup.update_attributes :status => 2
    redirect_to :controller => "startups", :action => "show", :id => params[:id]
  end

  def update_description
    startup = Startup.find(params[:id])
    startup.update_attributes :pitch => params[:pitch] if params[:pitch] and params[:pitch].length > 0
    respond_to do |format|
      format.js
    end
  end

  def update_name
    startup = Startup.find(params[:id])
    startup.update_attributes :name => params[:name] if params[:name] and params[:name].length > 0
    respond_to do |format|
      format.js
    end
  end

  def upload_logo
    @startup = Startup.find(params[:id])
    if @startup.update_attributes :avatar => params[:avatar]
      case params[:back_action]
        when "dashboard"
          redirect_to :controller => "startups", :action => "dashboard", :id => @startup.id and return
        when "about_step"
          redirect_to :controller => "campaigns", :action => "about_step" and return
      end
    end
  end

end
