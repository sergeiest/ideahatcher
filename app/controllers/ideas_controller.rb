class IdeasController < ApplicationController

  layout "hatcher"

  before_filter do
    wrong_link = 0

    case params[:action]
      when "create"
        wrong_link = 2 if session[:id] == nil || session[:id] == 0
    end


    case wrong_link
      when 1
        redirect_to :controller => 'authentications', :action => 'wrong_link'
      when 2
        render "authentications/join_login_form" and return
    end
  end

  def index
    @user = User.find(session[:id]) if session[:id] and session[:id] != 0
    session[:startup_id] = params[:id]
    @startup = Startup.find(params[:id])
    @startup_followers = @startup.Follower_users.all.uniq
    @startup_owners = @startup.Owner_users.all.uniq

    if session[:id] == nil || session[:id]== 0
      @reader_type = 0
    else
      if @startup_owners.first.id == session[:id]
        @reader_type = 3
      else
        if !@startup_followers.detect{|w| w.id == session[:id]}
          @reader_type = 2
        else
          @reader_type = 1
        end
      end
    end

    if @reader_type > 1
      @ideas = @startup.Ideas
    else
      @ideas = @startup.Ideas.find_all_by_is_protected(0)
    end


    @ideas.sort! { |a, b| [a['title'], a['created_at']] <=> [b['title'], b['created_at']] }

    @idea = Idea.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ideas }
    end

  end


  def create

    idea = Idea.new(params[:idea])


    if params[:idea][:content] == ""
      flash[:error] = "No message"
      return
    end


    if !session[:id] or session[:id] == 0
      flash[:error] = "PLease login first"
      return
    end

    user = User.find(session[:id])

    return if !user


    idea.last_name = user.lastname
    idea.first_name = user.firstname
    idea.user_id = user.id


    respond_to do |format|
      if idea.save
        if !idea.idea_id
          idea.idea_id = idea.id
          idea.update_attributes :idea_id => idea.id
        end
        #Do not sent an email!!!
        #email_idea(idea)
        format.html { redirect_to action: "index", id: idea.startup_id}
        @ideas = Array.new
        @ideas[0] = idea
        params[:id] = idea.companydescription_id
        format.js {render "show_idea"}
      else
        format.html { render action: "index", id: idea.startup_id }
        format.json { render json: idea.errors, status: :unprocessable_entity }
      end
    end
  end



  def email_idea(idea)
    users = Array.new
    owner = Owner.find_by_startup_id(idea.startup_id)
    user = User.find(owner.user_id)

    if idea.user_id != user.id
      users << user
    end

    if idea.idea_id != nil and idea.idea_id != idea.id
      all_ideas = Idea.find_all_by_idea_id(idea.idea_id)
      all_ideas.each do |comment|
        if comment.user_id != idea.user_id
            users << User.find(comment.user_id)
        end
      end
    end

    users.uniq!

    users.each do |f|
      email = Authentication.find(f.authentication_id).username
      UserMailer.send_idea(email, idea, f.firstname).deliver
    end
  end

  def show_idea
    @ideas = Idea.where(:companydescription_id => params[:id])
    @ideas.sort! { |a, b| [a['created_at']] <=> [b['created_at']] }
    # Delete id = params[:id]!!!
    respond_to do |format|
      format.js
    end
  end

  def idea_test
    @user = User.find(session[:id]) if session[:id] and session[:id] != 0
    session[:startup_id]= params[:id]
    @startup = Startup.find(params[:id])
    @startup_investors = @startup.Investor_users.all.uniq
    @startup_followers = @startup.Follower_users.all.uniq
    @startup_owners = @startup.Owner_users.all.uniq

    if session[:id] == nil || session[:id]== 0
      @reader_type = 0
    else
      if @startup_owners.first.id == session[:id]
        @reader_type = 3
      else
        if !@startup_followers.detect{|w| w.id == session[:id]}
          @reader_type = 2
        else
          @reader_type = 1
        end
      end
    end


    @ideas = @startup.Ideas.all

    @ideas.sort! { |a, b| [a['title'], a['created_at']] <=> [b['title'], b['created_at']] }

    @idea = Idea.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ideas }
    end

  end

  def hide_idea

  end


end