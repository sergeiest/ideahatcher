class StartupsController < ApplicationController

  layout "general"

  before_filter do
    wrong_link = 0
    case params[:action]
      when "team", "dashboard", "circles"
        if session[:id] == nil || session[:id] == 0
          wrong_link = 1
        else
          user = User.find(session[:id])
          if params[:id] and Owner.where("startup_id = ? AND user_id = ?", params[:id], session[:id]).length > 0
            session[:connection_type] = 2
            startup = Startup.find(params[:id])
            case startup.status
              when 0
                redirect_to :controller => 'campaigns', :action => 'about_step', :id => params[:id] and return
              when 1
                redirect_to :controller => 'campaigns', :action => 'circles_step', :id => params[:id] and return
            end
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
              connection_type = 2
              redirect_to :controller => 'startups', :action => 'dashboard', :id => params[:id] and return
            else
              if Follower.where("startup_id = ? AND user_id = ?", params[:id], session[:id]).length > 0
                connection_type = 1
              end
            end
            session[:connection_type] = connection_type
          else
            session[:connection_type] = 0
          end
        else
          wrong_link = 2
        end
      when "index", "hashtag", "my_ideas", "following_ideas"
        session[:connection_type] = nil
      else
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
    @startups = Startup.where("status > 1").all
    @startups.sort! {|y, x| x["status"] <=> y["status"]}
    @startups = @startups.sample(15)
    @startups_shown = 15

    tags = Tag.all

    @categories = Hash.new(0)

    tags.each do |tag|
      @categories[tag.name] += 1
    end

    @categories = @categories.keys.sort_by { |x| [@categories[x]* -1, x] }[0..9]

    respond_to do |format|
      format.html # index.html.erb
    end
  end


  def hashtag

    @user = User.find(session[:id])  if session[:id] and session[:id] != 0

    if !params[:tag] || params[:tag] == ""
      @startups = Startup.all[0..8]
    else
      tags = Tag.where("UPPER(name) LIKE UPPER(?)", params[:tag])
      @startups = Array.new
      tags.each do |tag|
        @startups << Startup.find(tag.startup_id)
      end
    end

    tags = Tag.all

    @categories = Hash.new(0)

    tags.each do |tag|
      @categories[tag.name] += 1
    end

    @categories = @categories.keys.sort_by { |x| [@categories[x]* -1, x] }[0..9]

    respond_to do |format|
      format.html {render "index"}
    end

  end


  def my_ideas

    if !session[:id] || session[:id] == 0
      redirect_to :action => "index" and return
    end

    @user = User.find(session[:id])

    @startups = @user.Owner_startups

    tags = Tag.all

    @categories = Hash.new(0)

    tags.each do |tag|
      @categories[tag.name] += 1
    end

    @categories = @categories.keys.sort_by { |x| [@categories[x]* -1, x] }[0..9]

    respond_to do |format|
      format.html {render "index"}
    end
  end


  def following_ideas

    if !session[:id] || session[:id] == 0
      redirect_to :action => "index" and return
    end

    @user = User.find(session[:id])

    @startups = @user.Follower_startups

    tags = Tag.all

    @categories = Hash.new(0)

    tags.each do |tag|
      @categories[tag.name] += 1
    end

    @categories = @categories.keys.sort_by { |x| [@categories[x]* -1, x] }[0..9]

    respond_to do |format|
      format.html {render "index"}
    end
  end

  def show
    @user = User.find(session[:id]) if session[:id] and session[:id] != 0
    @startup = Startup.find(params[:id])
    @startup_followers = @startup.Follower_users.all.uniq
    @startup_owners = @startup.Owner_users.all.uniq
    @startup_updates = @startup.Companyupdates
    @companyupdate = Companyupdate.new

    @company_descriptions = @startup.Companydescriptions.where("status =?", 1).sort!{|x, y| x["allfield_id"] <=> y["allfield_id"]}

    respond_to do |format|
      format.html # show.html.erb
    end

  end


  def circles
    @startup = Startup.find(session[:startup_id])
    @tags = @startup.Tags
    @people = User.all[0..5]
    @circles = @startup.Circle_users[0..39]
    @startup_owners = @startup.Owner_users.all.uniq
    @startup_followers = @startup.Follower_users.all.uniq
  end


  def dashboard
    @user = User.find(session[:id])   if session[:id] and session[:id] != 0
    @startup = Startup.find(session[:startup_id])
    @descriptions = @startup.Companydescriptions.where("status = ?",1)
    @startup_followers = @startup.Follower_users.all.uniq
    @startup_owners = @startup.Owner_users.all.uniq
    @companyupdate = Companyupdate.new
    @company_descriptions = @startup.Companydescriptions.where("status =?", 1).sort!{|x, y| x["allfield_id"] <=> y["allfield_id"]}
  end
  
  def team
    @startup = Startup.find(session[:startup_id])
    @startup_owners = @startup.Owner_users.all.uniq
    @startup_followers = @startup.Follower_users.all.uniq
    #@people = User.all[0..20]
  end

  def followers
    @startup = Startup.find(session[:startup_id])
    @people = @startup.Follower_users.all[0..20]
    @startup_owners = @startup.Owner_users.all.uniq
  end

  def idea_hatching
    @user = User.find(session[:id]) if session[:id] and session[:id] != 0
    @startup = Startup.find(params[:id])

    i=0
    @company_descriptions = @startup.Companydescriptions.where("status =?", 1).sort!{|x, y| x["allfield_id"] <=> y["allfield_id"]}

    @ideas = @startup.Ideas

    respond_to do |format|
      format.html # show.html.erb
    end


  end

  def search_startups
    if !params[:string] || params[:string] == ""
      @startups = Startup.all.sample(9)
    else
      s_name = params[:string]
      @startups = Startup.where("UPPER(name) LIKE UPPER(?)", "%" + s_name + "%")
      #startups_by_hashtag = Tag.where("UPPER(name) LIKE UPPER(?)", "%" + s_name + "%").sample(9)
      #startups_by_hashtag.each do |hashtag|
      #  @startups << Startup.find(hashtag.startup_id)
      #end
      @startups = @startups.uniq.sample(9)
    end

    @startups_shown = 0
    @startups_shown = 9 if @startups.length > 0

    respond_to do |format|
      format.js
    end
  end


  def show_more_startups

    add_startups = 6
    startup_list = params[:startup_list].split(",")
    @startups_shown = startup_list.length + add_startups
    @startups = Startup.where("status > 1").select {|x| !startup_list.include?(x.id.to_s()) }
    @startups_shown = 0 if @startups.length <= add_startups
    @startups = @startups.sample(add_startups)

    respond_to do |format|
      format.js
    end

  end



end
