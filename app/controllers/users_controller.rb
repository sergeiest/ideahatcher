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
    @notifications = @user.notifications.where("status = 1")
    #@notifications.uniq! {|a| a.event_type and a.event_id}
    @notifications.sort! {|y, x| x["created_at"] <=> y["created_at"]}

    @user.update_attribute(:notification_num, @notifications.length) if @notifications.length != @user.notification_num

    #@user_updates = Array.new
    #@user_startups.each do |startup|
    #  @user_updates << startup.companyupdates
    #end
    #if @user_updates != nil
    #  @user_updates.sort! { |y, x| x["newsdate"] <=> y["newsdate"] }
    #end

    ideas = Idea.where("user_id = ?", session[:id])

    startups_id = Array.new

    @user.owner_startups.each do |startup|
      startups_id << startup.id
    end

    @user.follower_startups.each do |startup|
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
    @funds = @user.funds
    @allfunds = Fund.all
  end

  def update
    @user = User.find(session[:id])
    if @user.update_attributes(params[:user])
      if not params[:occupation].nil?
        set_occu = @user.userinfos.find_by_status(3)
        if not set_occu.nil?
          set_occu.update_attributes(:content => params[:occupation])
        else
          occu = Userinfo.create(:user_id => @user.id, :status => 3, :content => params[:occupation])
          occu.save
        end
      end

      if not params[:project].nil?
        set_proj = @user.userinfos.find_by_status(4)
        if not set_proj.nil?
          if not params[:startup_id].nil?
            set_proj.update_attributes(:idea_id => params[:startup_id])
          end
          set_proj.update_attributes(:content => params[:project])
        else
          proj = Userinfo.create(:user_id => @user.id, :status => 4, :content => params[:project])
          if not params[:startup_id].nil?
            proj.idea_id = params[:startup_id]
          end
          proj.save
        end
      end

      flash[:success] = "Profile updated successfully"
      redirect_to :back
      #redirect_to :action =>'notifications', :id => params[:id]
    else
      render 'edit'
    end
  end


  def change_password
    @user = User.find(session[:id])
  end

end
