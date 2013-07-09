class UsersController < ApplicationController

  layout "hatcher"

  def index
    @user = User.find(params[:id])
    @user_startups = (@user.Owner_startups + @user.Investor_startups + @user.Follower_startups).uniq

    @notifications = @user.Notifications.where("status = 1")
    #@notifications.uniq! {|a| a.event_type and a.event_id}
    @notifications.sort! {|y, x| x["created_at"] <=> y["created_at"]}

    @user.update_attribute(:notification_num, @notifications.length)

    @user_startups.each do |startup|
      if @user_updates == nil
          @user_updates = startup.Companyupdates
      else
        @user_updates = @user_updates + startup.Companyupdates
      end
    end

    if @user_updates != nil
      @user_updates.sort! { |y, x| x["newsdate"] <=> y["newsdate"] }
    end

    if params[:id]==session[:id].to_s()
      session[:owner_type]=1
    else
      session[:owner_type]=0
    end


  end

  def notifications
    @user = User.find(params[:id])
    @user_startups = (@user.Owner_startups + @user.Investor_startups + @user.Follower_startups).uniq

    @notifications = @user.Notifications.where("status = 1")
    #@notifications.uniq! {|a| a.event_type and a.event_id}
    @notifications.sort! {|y, x| x["created_at"] <=> y["created_at"]}

    @user.update_attribute(:notification_num, @notifications.length)

    @user_startups.each do |startup|
      if @user_updates == nil
        @user_updates = startup.Companyupdates
      else
        @user_updates = @user_updates + startup.Companyupdates
      end
    end

    if @user_updates != nil
      @user_updates.sort! { |y, x| x["newsdate"] <=> y["newsdate"] }
    end

    if params[:id]==session[:id].to_s()
      session[:owner_type]=1
    else
      session[:owner_type]=0
    end

  end

  def ideas
    @user = User.find(params[:id])  if params[:id] and params[:id]!=0
    @ideas = Idea.where("user_id = ?", session[:id])
    @ideas.uniq! {|a| a.companydescription_id}
    @ideas.sort! { |a, b| [a['title'], a['created_at']] <=> [b['title'], b['created_at']] }
  end

  def my_account
  end
  
  def show
  end

  
  def edit
    @user = User.find(session[:id])
    session[:owner_type] == 1

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  def update

    @user = User.find(session[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated successfully"
      # sign_in @user
      redirect_to :action =>'index', :id => params[:id]
    else
      render 'edit'

    end
  end


  def change_password
    @user = User.find(session[:id])


  end

  
end
