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

  def hide_idea

  end


end