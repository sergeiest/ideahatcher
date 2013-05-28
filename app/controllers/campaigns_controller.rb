class CampaignsController < ApplicationController
  # GET /campaigns
  # GET /campaigns.json

  layout :layout_by_resource

  def layout_by_resource
    case params[:action]
      when 'index'
        "hatcher"
      else
        "hatcher"
    end
  end

  before_filter do
    wrong_link = 0
    if session[:id] == nil || session[:id] == 0
      wrong_link = 1
    else
      case params[:action]
        when "index"
          if Fund.find_all_by_user_id(session[:id]) == nil
            wrong_link = 1
          end
        when "about_step", "description_step", "team_step", "team_save_step", "review_step", "upload_logo", "update",
                      "destroy", "publish_step", "circles_step"
          user = User.find(session[:id])
          session[:startup_id] = user.Owner_startups.first.id
        when "next_step"
        when "guide_step", "basic_step", "create_step"
          user = User.find(session[:id])
          startup = user.Owner_startups.first
          if startup == nil
            session[:startup_id] = nil
          else
            session[:startup_id] = startup.id
          end
        else
            wrong_link = 1
      end

    end
    if wrong_link == 1
      redirect_to :controller => 'authentications', :action => 'wrong_link'
    end
  end

  def index
    @campaigns = Campaign.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @campaigns }
    end
  end

  def guide_step
    if session[:id] != nil and session[:id] != 0
      @startup = User.find(session[:id]).Owner_startups.first
    else
      @startup = nil
    end
  end

  def next_step

    #if user.Owner_startups == nil
        redirect_to  :action =>'basic_step'
    #  else
    #    redirect_to  :action =>'guide_step'
    #end
  end

  def basic_step
     if session[:startup_id] != nil
       @startup = Startup.find(session[:startup_id])
       session[:startup_id] = @startup.id
       @campaign = @startup.Campaign
     else
       session[:startup_id] = nil
       @campaign = Campaign.new
       @startup = Startup.new
     end
  end

  def create_step

    params[:campaign][:closing_date] = Date.today
    params[:startup][:status] = 1

    if session[:startup_id] == nil
      @startup = Startup.new(params[:startup])
      if params[:is] != nil and params[:is][:campaign]=="1"
        @campaign = @startup.create_Campaign(params[:campaign])
        @campaign.raised_sum = 0
        @campaign.status = 1
        @campaign.valuation_sum = get_valuation(@campaign.goal_sum,@campaign.share)
      end
    else
      @startup = Startup.find(session[:startup_id])
      @campaign = @startup.Campaign
      if @campaign == nil
        if params[:is] != nil and params[:is][:campaign] == "1"
          @campaign = @startup.create_Campaign(params[:campaign])
          @campaign.raised_sum = 0
          @campaign.status = 1
          @campaign.valuation_sum = get_valuation(@campaign.goal_sum,@campaign.share)
        end
      end
    end

    startup_errors = Startup.check_errors(params[:startup])
    if params[:is] == nil ||  params[:is][:campaign] == "1"
      campaign_errors = Campaign.check_errors(params[:campaign])
    end

    if startup_errors != nil || campaign_errors != nil
      if startup_errors != nil
        @startup.errors.add startup_errors.partition("/")[0]  , startup_errors.partition("/")[2]
        respond_to  do |format|
          format.html { render action: "basic_step" }
          format.json { render json: @startup }
        end
      else
        if @campaign == nil
          @campaign = Campaign.new(params[:campaign])
        end
        @campaign.errors.add campaign_errors.partition("/")[0]  , campaign_errors.partition("/")[2]
        respond_to  do |format|
          format.html { render action: "basic_step" }
          format.json { render json: @campaign }
        end
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
            format.html { redirect_to action: 'about_step'}
          else
            format.html { render action: "basic_step"}
          end
        end
      else
        if @campaign == nil
          respond_to do |format|
            if @startup.update_attributes(params[:startup])
              format.html { redirect_to action: 'about_step'}
            else
              format.html { render action: "basic_step"}
            end
          end
        else
          respond_to do |format|
            if @startup.update_attributes(params[:startup]) and @campaign.update_attributes(params[:campaign])
              format.html { redirect_to action: 'about_step'}
            else
              format.html { render action: "basic_step"}
            end
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
          @companydescriptions1 = @startup.Companydescriptions.find_by_allfield_id(allfield.id)
          if @companydescriptions1 == nil
            @companydescriptions1 = Companydescription.new
            @companydescriptions1.allfield_id = allfield.id
          end
        when 2
          @companydescriptions2 = @startup.Companydescriptions.find_by_allfield_id(allfield.id)
          if @companydescriptions2 == nil
            @companydescriptions2 = Companydescription.new
            @companydescriptions2.allfield_id = allfield.id
          end
        when 3
          @companydescriptions3 = @startup.Companydescriptions.find_by_allfield_id(allfield.id)
          if @companydescriptions3 == nil
            @companydescriptions3 = Companydescription.new
            @companydescriptions3.allfield_id = allfield.id
          end
      end
    end
  end

  def description_step

    #Works only for 3 fields!

    startup =Startup.find(session[:startup_id])

    no_errors = 1

    companydescriptions1 =startup.Companydescriptions.find_by_allfield_id(params[:companydescriptions1][:allfield_id])
    if companydescriptions1 == nil
      companydescriptions1 = Companydescription.new(params[:companydescriptions1])
      companydescriptions1.startup_id = session[:startup_id]
      no_errors = 0 if !companydescriptions1.save
    else
      no_errors = 0 if !companydescriptions1.update_attributes(params[:companydescriptions1])
    end

    companydescriptions2 = startup.Companydescriptions.find_by_allfield_id(params[:companydescriptions2][:allfield_id])
    if companydescriptions2 == nil
      companydescriptions2 = Companydescription.new(params[:companydescriptions2])
      companydescriptions2.startup_id = session[:startup_id]
      no_errors = 0 if !companydescriptions2.save
    else
      no_errors = 0 if !companydescriptions2.update_attributes(params[:companydescriptions2])
    end

    companydescriptions3 = startup.Companydescriptions.find_by_allfield_id(params[:companydescriptions3][:allfield_id])
    if companydescriptions3 == nil
      companydescriptions3 = Companydescription.new(params[:companydescriptions3])
      companydescriptions3.startup_id = session[:startup_id]
      no_errors = 0 if !companydescriptions3.save
    else
      no_errors = 0 if !companydescriptions3.update_attributes(params[:companydescriptions3])
    end

    respond_to do |format|
      if no_errors == 1
        format.html { redirect_to action: 'circles_step'}
      else
        format.html { render action: 'about_step'}
      end
    end
  end

  def circles_step
    @startup =Startup.find(session[:startup_id])
    @tags = @startup.Tags
    @people = User.all[0..5]
    @circles = User.all[0..9]
  end

  def review_step
    @startup =Startup.find(session[:startup_id])
    @campaign = @startup.Campaign

    i=0
    for allfield in Allfield.find_all_by_view_flag(3)
      i = i +1
      case i
        when 1
          @company_description_1 = @startup.Companydescriptions.find_by_allfield_id(allfield.id)
        when 2
          @company_description_2 = @startup.Companydescriptions.find_by_allfield_id(allfield.id)
        when 3
          @company_description_3 = @startup.Companydescriptions.find_by_allfield_id(allfield.id)
      end
    end

    @startup_teams = @startup.Companyteams


  end

  def publish_step
    @startup =Startup.find(session[:startup_id])
    if params[:publish_check] == "1"
      status = 2
    else
      status = 1
    end
    respond_to do |format|
      if @startup.update_attributes :status =>  status
        format.html { redirect_to controller: "startups", action: "show", id: session[:startup_id] }
      else
        @startup.errors.add :avatar, "Invalid photo format"
        format.html { render action: "review_step" }
        format.json { render json: @startup.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload_logo
    @startup = Startup.find(session[:startup_id])
    respond_to do |format|
      if @startup.update_attributes :avatar => params[:startup][:avatar]
        format.html { redirect_to action: "about_step", id: session[:startup_id] }
      else
        @startup.errors.add :avatar, "Invalid photo format"
        format.html { render action: "about_step" }
        format.json { render json: @startup.errors, status: :unprocessable_entity }
      end
    end
  end

  def summary
    @startup =Startup.find(session[:startup_id])
    @campaign = @startup.Campaign
    @allfields = Allfield.find_all_by_view_flag(3)
  end

end
