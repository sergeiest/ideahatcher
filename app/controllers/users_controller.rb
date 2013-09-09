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
    @user_startups = (@user.Owner_startups + @user.Investor_startups + @user.Follower_startups).uniq

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

    @ideas = Idea.where("user_id = ?", session[:id])
    @ideas.uniq! {|a| a.companydescription_id}
    @ideas.sort! { |b, a| [a['created_at'], a['title']] <=> [b['created_at'], b['title'] ] }

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
