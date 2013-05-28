class StartupsController < ApplicationController

  layout :layout_by_resource

  def layout_by_resource
    case params[:action]
      when 'index', 'vote_lightning', 'show', 'team', 'detailed', 'circle', 'dashboard'
        "hatcher"
      else
        "demo"
    end
  end

  before_filter do
    wrong_link = 0
    case params[:action]
      when "team", "detailed", "dashboard", "circle"
        if session[:id] == nil || session[:id] == 0
          wrong_link = 1
        else
          user = User.find(session[:id])
          if params[:id] and Owner.where("startup_id = ? AND user_id = ?", params[:id], session[:id]).length > 0
            session[:startup_id] = params[:id]
          else
            wrong_link = 1
          end
        end
      when "show"
        if params[:id] and Startup.find(params[:id])
          session[:startup_id] = params[:id]
          if session[:id] != 0 and session[:id] != nil
            connection_type=0
            if Owner.where("startup_id = ? AND user_id = ?", params[:id], session[:id]).length > 0
              connection_type=2
            end
            session[:connection_type] = connection_type
          else
            session[:connection_type] = 0
          end
        else
          wrong_link = 2
        end
      when "index"
        session[:startup_id] = nil
        session[:connection_type] = nil
    end
    case wrong_link
      when 1
        redirect_to :controller => 'authentications', :action => 'wrong_link'
      when 2
        redirect_to :controller => 'startups', :action => 'index'
    end
  end

  def index
    @user = User.find(session[:id])  if session[:id] and session[:id] != 0
    @startups = Startup.where("status > 2").all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @startups }
    end
  end

  def show
    @user = User.find(session[:id])
    @startup = Startup.find(params[:id])
    @startup_followers = @startup.Follower_users.all.uniq
    @startup_owners = @startup.Owner_users.all.uniq
    @startup_updates = @startup.Companyupdates
    @companyupdate = Companyupdate.new

    i=0
    @company_descriptions = Array.new
    for allfield in Allfield.find_all_by_view_flag(3)
      @company_descriptions[i] = @startup.Companydescriptions.where("allfield_id =? AND status =?", allfield.id, 1)[0]
      i = i + 1 if @company_descriptions[i]
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @startup }
    end

  end

  def circle
    @startup = Startup.find(session[:startup_id])
    @tags = @startup.Tags
  end

  def dashboard
    @user = User.find(session[:id])   if session[:id] and session[:id] != 0
    @startup = Startup.find(params[:id])
    @descriptions = @startup.Companydescriptions.where("status = ?",1)

  end
  
  def detailed
    @user = User.find(session[:id])   if session[:id] and session[:id] != 0
    @startup = Startup.find(session[:startup_id])
    @descriptions = @startup.Companydescriptions.where("status = ?",1)
  end
  
  def team
    @startup = Startup.find(session[:startup_id])
    @startup_owners = @startup.Owner_users.all.uniq
    @people = User.all[0..20]
  end

  def search_startups
    redirect_to :action => "index"
  end

  def vote_lightning

    if !params[:id0] || params[:id0] == 0 || !params[:id1] || params[:id1] == 0 || !params[:id2] || params[:id2] == 0
      redirect_to :action => "vote_next", :id0 => params[:id0], :id1 => params[:id1],:id2 => params[:id2] and return
    end

    @startups = Array.new
    @startups[0]=Startup.find(params[:id0])
    @startups[1]=Startup.find(params[:id1])
    @startups[2]=Startup.find(params[:id2])

  end

  def vote_next

    if !params[:id0] || params[:id0] == 0 || !params[:id1] || params[:id1] == 0 || !params[:id2] || params[:id2] == 0
      not_used_startups = Startup.all
    end

    a = Array.new
    if !params[:id0] || params[:id0] == 0
      a[0] =  rand(not_used_startups.length)
      params[:id0] = not_used_startups[a[0]].id
    end

    if !params[:id1] || params[:id1] == 0
      a[1] =  rand(not_used_startups.length)
      params[:id1] = not_used_startups[a[1]].id
    end
    if !params[:id2] || params[:id2] == 0
      a[2] =  rand(not_used_startups.length)
      params[:id2] = not_used_startups[a[2]].id
    end

    redirect_to :action => "vote_lightning", :id0 => params[:id0], :id1 => params[:id1],:id2 => params[:id2]
  end



end
