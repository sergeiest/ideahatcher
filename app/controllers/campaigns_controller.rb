class CampaignsController < ApplicationController
  # GET /campaigns
  # GET /campaigns.json

  layout "hatcher"

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
        when "next_step"
        when "guide_step", "basic_step", "create_step"
          session[:startup_id] = nil
        when "about_step", "description_step", "upload_logo", "update",
            "destroy", "publish_step", "circles_step", "update_description", "update_name"
          user = User.find(session[:id])
          if user.nil? or Owner.where("startup_id = ? AND user_id = ?", params[:id], session[:id]).length == 0
            wrong_link = 1
          else
            session[:startup_id] = params[:id]
          end
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

    #if user.Owner_startups == nil
        redirect_to  :action =>'basic_step'
    #  else
    #    redirect_to  :action =>'guide_step'
    #end
  end

  def basic_step
     @startup = Startup.new
  end



  def create_step

    if session[:startup_id] == nil
      params[:startup][:status] = 0
      @startup = Startup.new(params[:startup])
    else
      @startup = Startup.find(session[:startup_id])
    end

    startup_errors = Startup.check_errors(params[:startup])

    if startup_errors != nil
      @startup.errors.add startup_errors.partition("/")[0]  , startup_errors.partition("/")[2]
      respond_to  do |format|
        format.html { render action: "basic_step" }
        format.json { render json: @startup }
      end
    else
      if session[:startup_id] == nil
        respond_to do |format|
          if @startup.save
            session[:startup_id] = @startup.id
            owner = Owner.new
            owner.startup_id = @startup.id
            owner.user_id = session[:id]
            owner.status = 1
            owner.save
            format.html { redirect_to action: 'about_step', :id => session[:startup_id]}
          else
            format.html { render action: "basic_step"}
          end
        end
      else
        respond_to do |format|
          if @startup.update_attributes(params[:startup])
            format.html { redirect_to action: 'about_step', :id => session[:startup_id]}
          else
            format.html { render action: "basic_step"}
          end
        end
      end
    end


  end

  def about_step
    @startup = Startup.find(session[:startup_id])

    # Works only for 3 fields!

    i=0
    for allfield in Allfield.find_all_by_view_flag(3)
      i = i +1
      case i
        when 1
          @companydescriptions1 = @startup.Companydescriptions.where("allfield_id = ? AND status = 1",allfield.id)[0]
          if @companydescriptions1 == nil
            @companydescriptions1 = Companydescription.new
            @companydescriptions1.allfield_id = allfield.id
          end
        when 2
          @companydescriptions2 = @startup.Companydescriptions.where("allfield_id = ? AND status = 1",allfield.id)[0]
          if @companydescriptions2 == nil
            @companydescriptions2 = Companydescription.new
            @companydescriptions2.allfield_id = allfield.id
          end
        when 3
          @companydescriptions3 = @startup.Companydescriptions.where("allfield_id = ? AND status = 1",allfield.id)[0]
          if @companydescriptions3 == nil
            @companydescriptions3 = Companydescription.new
            @companydescriptions3.allfield_id = allfield.id
          end
      end
    end
  end

  def description_step

    #Works only for 3 fields!

    startup = Startup.find(session[:startup_id])

    no_errors = 1

    all_descriptions = startup.Companydescriptions.where("status = 1")


    params_descriptions = Array.new

    params_descriptions[0] = Companydescription.new
    params_descriptions[0].allfield_id = params[:companydescriptions1][:allfield_id]
    params_descriptions[0].content = params[:companydescriptions1][:content]
    params_descriptions[0].field_status = params[:companydescriptions1][:field_status]

    params_descriptions[1] = Companydescription.new
    params_descriptions[1].allfield_id = params[:companydescriptions2][:allfield_id]
    params_descriptions[1].content = params[:companydescriptions2][:content]
    params_descriptions[1].field_status = params[:companydescriptions2][:field_status]

    params_descriptions[2] = Companydescription.new
    params_descriptions[2].allfield_id = params[:companydescriptions3][:allfield_id]
    params_descriptions[2].content = params[:companydescriptions3][:content]
    params_descriptions[2].field_status = params[:companydescriptions3][:field_status]




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
        description.startup_id = session[:startup_id]
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
    @startup = Startup.find(session[:startup_id])
    @tags = @startup.Tags
    @people = User.all[0..5]
    @circles = User.all[0..9]
  end

  def publish_step
    startup = Startup.find(session[:startup_id])
    startup.update_attributes :status => 2
    redirect_to :controller => "startups", :action => "show", :id => session[:startup_id]
  end

  def update_description
    startup = Startup.find(session[:startup_id])
    startup.update_attributes :pitch => params[:pitch] if params[:pitch] and params[:pitch].length > 0
    respond_to do |format|
      format.js
    end
  end

  def update_name
    startup = Startup.find(session[:startup_id])
    startup.update_attributes :name => params[:name] if params[:name] and params[:name].length > 0
    respond_to do |format|
      format.js
    end
  end

  def upload_logo
    @startup = Startup.find(session[:startup_id])
    if @startup.update_attributes :avatar => params[:avatar]
      case params[:back_action]
        when "detailed"
          redirect_to :controller => "startups", :action => "detailed", :id => @startup.id and return
        when "about_step"
          redirect_to :controller => "campaigns", :action => "about_step" and return
      end
    end
  end

end
