class StartupsController < ApplicationController

  layout :layout_by_resource

  def layout_by_resource
    case params[:action]
      when 'index', 'show', 'team', 'detailed'
        "main"
      when 'vote_lightning'
        "hatcher"
      else
        "application"
    end
  end



  before_filter do
    wrong_link = 0
    case params[:action]
      when "update"
        if session[:id] == nil || session[:id] == 0
          wrong_link = 1
        else
          user = User.find(session[:id])
          session[:startup_id] = user.Owner_startups.first.id
          if session[:startup_id] == nil
            wrong_link = 1
          end
        end
    end
    if wrong_link == 1
      redirect_to :controller => 'authentications', :action => 'wrong_link'
    end
    if wrong_link == 2
      redirect_to :controller => 'home', :action => 'index'
    end
  end


  def index
    @user = User.find(session[:id])  if session[:id] and session[:id] != 0
    @startups = Startup.where(:status => 4)
    @startups_no_capmaign = Startup.where(:status => 3)

    session[:startup_id] = nil
    session[:connection_type] = nil

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @startups }
    end
  end

  def show
    @startup = Startup.find(params[:id])
    @startup_investors = @startup.Investor_users.all.uniq
    @startup_followers = @startup.Follower_users.all.uniq
    @startup_owners = @startup.Owner_users.all.uniq
    @allfield = Allfield.find_by_view_flag(1)
    @startup_description = @startup.Companydescriptions.find_by_allfield_id(@allfield.id)
    @startup_teams = @startup.Companyteams
    @startup_updates = @startup.Companyupdates
    @companyupdate = Companyupdate.new

    session[:startup_id] = @startup.id

    if session[:id] != 0 and session[:id] != nil
      @user = User.find(session[:id])

      connection_type=0
      if @startup_followers.include? @user
        connection_type=1
      end
      if @startup_owners.include? @user
        connection_type=2
      end

      session[:connection_type] = connection_type

    else
      session[:connection_type] = 0
    end

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


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @startup }
    end
    
  end


  def new
    @startup = Startup.new

   # respond_to do |format|
   #   format.html # new.html.erb
   #   format.json { render json: @startup }
   # end
  end


  def edit
    @startup = Startup.find(session[:startup_id])
  end
  
  #def editcapital
    #@startup = Startup.find(session[:startup_id])
  #end

  def update
    startup = Startup.find(session[:startup_id])

    respond_to do |format|
      if startup.update_attributes(params[:startup])
        format.html { redirect_to controller: 'campaigns', action: 'about_step'}
        format.json { head :no_content }
      else
        format.html { redirect_to controller: 'campaigns', action: 'about_step'}
        format.json { render json: @companyteam.errors, status: :unprocessable_entity }
      end
    end
  end


  def developermode
    @startups = Startup.all
  end
  
  def detailed
    @user = User.find(session[:id])   if session[:id] and session[:id] != 0
    @startup = Startup.find(session[:startup_id])
    @companydescriptions = @startup.Companydescriptions.where("status = ?",1)
    @startup_investors = @startup.Investor_users.all.uniq
    @startup_followers = @startup.Follower_users.all.uniq
    @startup_owners = @startup.Owner_users.all.uniq
  end
  
  def mentors
    @startup = Startup.find(session[:startup_id])
    @startup_investors = @startup.Investor_users.all.uniq
    @startup_followers = @startup.Follower_users.all.uniq
    @startup_owners = @startup.Owner_users.all.uniq

  end
  
  def team
    @user = User.find(session[:id])   if session[:id] and session[:id] != 0
    @startup = Startup.find(session[:startup_id])
    @startup_teams = @startup.Companyteams
    @startup_investors = @startup.Investor_users.all.uniq
    @startup_followers = @startup.Follower_users.all.uniq
    @startup_owners = @startup.Owner_users.all.uniq
  end

  def documents
  end

  def search_startups
    redirect_to :action => "index"
  end

  def vote_like
    startup = Startup.find(params[:id])
    @company_descriptions = startup.Companydescriptions
    respond_to do |format|
      format.js
    end
  end

  def vote_not_clear
    respond_to do |format|
      format.js
    end
  end

  def vote_dislike
    respond_to do |format|
      format.js
    end
  end


  def vote_lightning

    if !params[:id] || params[:id] == 0
      startups = Startup.all
      params[:id] = startups[rand(startups.length)].id
    end

    @startup = Startup.find(params[:id])
    @startup_teams = @startup.Companyteams
    @company_descriptions = @startup.Companydescriptions


  end

  def vote_next
    id = params[:id]
    if !id || id == 0
      startups = Startup.all
    else
      startups = Startup.where('id != ?', id)
    end
    id = startups[rand(startups.length)].id if startups.length > 0
    redirect_to :action => "vote_lightning", :id => id
  end



end
