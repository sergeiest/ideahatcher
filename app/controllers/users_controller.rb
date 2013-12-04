class UsersController < ApplicationController

  layout "general"


  before_filter do
    wrong_link = 0
    wrong_link = 1 if session[:id] == nil || session[:id] == 0
    case wrong_link
      when 1
        redirect_to :controller => 'authentications', :action => 'wrong_link'
    end
  end



  def index
    redirect_to :action =>'notifications', :id => params[:id]
  end

  def notifications

    @user = User.find(params[:id])
    @notifications = @user.Notifications.where("status = 1")
    #@notifications.uniq! {|a| a.event_type and a.event_id}
    @notifications.sort! {|y, x| x["created_at"] <=> y["created_at"]}

    @user.update_attribute(:notification_num, @notifications.length) if @notifications.length != @user.notification_num

    #@user_updates = Array.new
    #@user_startups.each do |startup|
    #  @user_updates << startup.Companyupdates
    #end
    #if @user_updates != nil
    #  @user_updates.sort! { |y, x| x["newsdate"] <=> y["newsdate"] }
    #end

    ideas = Idea.where("user_id = ?", session[:id])

    startups_id = Array.new

    @user.Owner_startups.each do |startup|
      startups_id << startup.id
    end

    @user.Follower_startups.each do |startup|
      startups_id << startup.id
    end

    ideas.each do |idea|
      startups_id << idea.startup_id
    end

    startups_id.uniq!

    query_str = ""
    startups_id.each do |startup_id|
      if query_str == ""
        query_str = "startup_id = " + startup_id.to_s
      else
        query_str += " OR startup_id = " + startup_id.to_s if startup_id
      end
    end

    @ideas = Idea.where(query_str)
    #@ideas.uniq! {|a| a.companydescription_id}
    @ideas.sort! { |b, a| [a['created_at']] <=> [b['created_at']] }
    @ideas = @ideas[0..20]

  end

  def edit
    @user = User.find(session[:id])
  end

  def update
    @user = User.find(session[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated successfully"
      redirect_to :action =>'notifications', :id => params[:id]
    else
      render 'edit'
    end
  end


  def change_password
    @user = User.find(session[:id])
  end

end
