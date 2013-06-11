class StartupsController < ApplicationController

  layout :layout_by_resource

  def layout_by_resource
    case params[:action]
      when 'index', 'vote_lightning', 'show', 'team', 'detailed', 'circle', 'dashboard', "ab_testing"
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
            session[:connection_type] = 2
          else
            wrong_link = 1
          end
        end
      when "show", "ab_testing"
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
    @user = User.find(session[:id]) if session[:id] and session[:id] != 0
    @startup = Startup.find(params[:id])
    @startup_followers = @startup.Follower_users.all.uniq
    @startup_owners = @startup.Owner_users.all.uniq
    @startup_updates = @startup.Companyupdates
    @companyupdate = Companyupdate.new

    @company_descriptions = @startup.Companydescriptions.where("status =?", 1)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @startup }
    end

  end

  def circle
    @startup = Startup.find(session[:startup_id])
    @tags = @startup.Tags
    @people = User.all[0..5]
    @circles = User.all[0..9]
  end

  def dashboard
    @user = User.find(session[:id])   if session[:id] and session[:id] != 0
    @startup = Startup.find(params[:id])
    @descriptions = @startup.Companydescriptions.where("status = ?",1)
    @ideas = @startup.Ideas

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

  def ab_testing
    @user = User.find(session[:id]) if session[:id] and session[:id] != 0
    @startup = Startup.find(params[:id])

    i=0
    @company_descriptions = @startup.Companydescriptions.where("status =?", 1)

    @ideas = @startup.Ideas

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @startup }
    end


  end

  def search_startups
    redirect_to :action => "index"
  end

  def vote_lightning

    if !params[:id0] || params[:id0] == 0 || !params[:id1] || params[:id1] == 0 || !params[:id2] || params[:id2] == 0
      redirect_to :action => "vote_next", :id0 => params[:id0], :id1 => params[:id1],:id2 => params[:id2] and return
    else
      if params[:id0] == params[:id1] || params[:id1] == params[:id2] || params[:id2] == params[:id0]
        redirect_to :action => "vote_next", :id0 => params[:id0], :id1 => params[:id1],:id2 => params[:id2] and return
      end
    end

    @startups = Array.new
    @startups[0]=Startup.find(params[:id0])
    @startups[1]=Startup.find(params[:id1])
    @startups[2]=Startup.find(params[:id2])

  end

  def vote_next

    not_used_startups = Startup.all


    if params[:id0] || not_used_startups.select{|a| a.id == params[:id0].to_i()}.length > 0
      not_used_startups = not_used_startups.select{|a| a.id != params[:id0].to_i()}
    else
      params[:id0] = nil
    end

    if params[:id1] || not_used_startups.select{|a| a.id == params[:id1].to_i()}.length > 0
      not_used_startups = not_used_startups.select{|a| a.id != params[:id1].to_i()}
    else
      params[:id1] = nil
    end

    if params[:id2] || not_used_startups.select{|a| a.id == params[:id2].to_i()}.length > 0
      not_used_startups = not_used_startups.select{|a| a.id != params[:id2].to_i()}
    else
      params[:id1] = nil
    end

    ids = not_used_startups.sample(3)

    a = Array.new
    if !params[:id0]
      a[0] = ids[0].id
    else
      a[0] = params[:id0]
    end

    if !params[:id1]
      a[1] = ids[1].id
    else
      a[1] = params[:id1]
    end

    if !params[:id2]
      a[2] = ids[2].id
    else
      a[2] = params[:id2]
    end
    
    redirect_to :action => "vote_lightning", :id0 => a[0], :id1 => a[1],:id2 => a[2]
  end


end
