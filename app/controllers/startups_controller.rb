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
          startups = user.owner_startups
          if params[:id] == nil
            if startups.length == 0
              redirect_to :controller => 'campaigns', :action => 'guide_step' and return
            else
              params[:id] = startups[0].id
            end
          end
          startup_with_id = user.owner_startups.where("startup_id = ?", params[:id])
          if startup_with_id.length != 0
            session[:connection_type] = 2
            startup = startup_with_id[0]
            case startup.status
              when 0
                redirect_to :controller => 'campaigns', :action => 'about_step', :id => params[:id] and return
              when 1
                redirect_to :controller => 'campaigns', :action => 'circles_step', :id => params[:id] and return
            end
          else
            redirect_to :controller => 'campaigns', :action => 'guide_step' and return
          end
        end

      when "show"
        if params[:id]
          startup = Startup.find(params[:id])
          connection_type=0
          if session[:id] != 0 and session[:id] != nil
            if Owner.where("startup_id = ? AND user_id = ?", params[:id], session[:id]).length > 0
              connection_type = 2
              redirect_to :controller => 'startups', :action => 'dashboard', :id => params[:id] and return
            else
              connection_type = 1 if Follower.where("startup_id = ? AND user_id = ?", params[:id], session[:id]).length > 0
            end
          else
          end
          session[:connection_type] = connection_type

          circles = startup.circles
          if circles.select{|x| x.user_id == 0}.length == 0 and
               (session[:id].nil? || circles.select{|x| (x.status != 3 and x.user_id == session[:id])}.length == 0)
            redirect_to :controller => 'startups', :action => 'request_access', :id => params[:id] and return
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

    @tags = Tag.all

    @categories = Hash.new(0)

    @tags.each do |tag|
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

    @startups = @user.owner_startups

    @tags = Tag.all

    @categories = Hash.new(0)

    @tags.each do |tag|
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

    @startups = @user.follower_startups

    @tags = Tag.all

    @categories = Hash.new(0)

    @tags.each do |tag|
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
    @startup_followers = @startup.follower_users.all.uniq
    @startup_owners = @startup.owner_users.all.uniq
    @tags = Tag.all
    @ideas = @startup.ideas


    @company_descriptions_all = @startup.companydescriptions
    @company_descriptions = @company_descriptions_all.select{|x| x.status == 1}.sort!{|x, y| x["allfield_id"] <=> y["allfield_id"]}


    respond_to do |format|
      format.html # show.html.erb
    end

  end

  def request_access
    @user = User.find(session[:id]) if session[:id] and session[:id] != 0
    @startup = Startup.find(params[:id])
    @tags = Tag.all
  end


  def circles
    @user = User.find(session[:id])
    @startup = Startup.find(params[:id])
    @tags = @startup.tags
    @circles = @startup.circle_users[0..39]
    @funds = @startup.investor_funds

    @circle_type = 0
    @circle_type = 3 if @startup.circles.any?{|x| x.user_id == 0}
    @circle_type = 1 if @circle_type == 0 and @circles.length > 0

  end


  def dashboard
    @user = User.find(session[:id])   if session[:id] and session[:id] != 0
    @startup = Startup.find(params[:id])
    @descriptions = @startup.companydescriptions.where("status = ?",1)
    @startup_followers = @startup.follower_users.all.uniq
    @startup_owners = @startup.owner_users.all.uniq
    @company_descriptions_all = @startup.companydescriptions
    @company_descriptions = @company_descriptions_all.select{|x| x.status == 1}.sort!{|x, y| x["allfield_id"] <=> y["allfield_id"]}
    @ideas = @startup.ideas
    @pictures = @startup.pictures

  end
  
  def team
    @user = User.find(session[:id])   if session[:id] and session[:id] != 0
    @startup = Startup.find(params[:id])
    @startup_owners = @startup.owner_users.all.uniq
    @startup_followers = @startup.follower_users.all.uniq
    #@people = User.all[0..20]
  end

  def followers
    @startup = Startup.find(params[:id])
    @people = @startup.follower_users.all[0..20]
    @startup_owners = @startup.owner_users.all.uniq
  end

  #def idea_hatching
  #  @user = User.find(session[:id]) if session[:id] and session[:id] != 0
  #  @startup = Startup.find(params[:id])
  #
  #  i=0
  #  @company_descriptions = @startup.companydescriptions.where("status =?", 1).sort!{|x, y| x["allfield_id"] <=> y["allfield_id"]}
  #
  #  @ideas = @startup.ideas
  #
  #  respond_to do |format|
  #    format.html # show.html.erb
  #  end
  #
  #
  #end

  def search_startups
    if !params[:string] || params[:string] == ""
      @startups = Startup.all.sample(9)
    else
      s_name = params[:string]
      query_str = "UPPER(name) LIKE UPPER('%" + s_name + "%')"

      @tags = Tag.all


      hashtags = @tags.select {|x| x.name.downcase.include? s_name.downcase}.sample(9)
      hashtags.each do |hashtag|
        query_str = query_str + " OR id = " + hashtag.startup_id.to_s()
      end

      @startups = Startup.where(query_str).sample(9)

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
    @tags = Tag.all

    respond_to do |format|
      format.js
    end

  end



end
