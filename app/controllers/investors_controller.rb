class InvestorsController < ApplicationController
  # GET /investors
  # GET /investors.json


  layout 'general'

  before_filter do
    wrong_link = 0
    case params[:action]
      when "follow_company"
        wrong_link = 2 if session[:id] == nil || session[:id] == 0
      when "add_founder", "remove_founder"
        if params[:id].nil? || session[:id].nil? || session[:id] == 0 || Startup.find(params[:id]).nil?
          wrong_link = 1
        end
      when "share_with_fund"
        if session[:id] == nil || session[:id] == 0 || params[:startup_id] == nil
          wrong_link = 1
        else
          wrong_link = 1 if Owner.where("startup_id = ? AND user_id = ?", params[:startup_id], session[:id]).length == 0
        end
      when "last_activities"
        wrong_link = 1 if (session[:id] != 1 and session[:id] != 61 and session[:id] != 62 and session[:id] != 50)
    end

    case wrong_link
      when 1
        redirect_to :controller => 'authentications', :action => 'wrong_link'
      when 2
        render "authentications/join_login_form" and return
    end
  end






  def index

  end

  def last_activities

    @users = User.all
    @startups = Startup.all
    @ideas = Idea.all

  end



  # PUT /investors/1
  # PUT /investors/1.json
  def update
    @investor = Investor.find(params[:id])

    respond_to do |format|
      if @investor.update_attributes(params[:investor])
        format.html { redirect_to @investor, notice: 'Investor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @investor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /investors/1
  # DELETE /investors/1.json
  def destroy
    @investor = Investor.find(params[:id])
    @investor.destroy

    respond_to do |format|
      format.html { redirect_to investors_url }
      format.json { head :no_content }
    end
  end
  
    
  def follow_company

    user = User.find(session[:id])
    startup = Startup.find(params[:id])

    if !user || !startup
      return
    end

    respond_to do |format|
      if !params[:unfollow] or (params[:unfollow] != 1 and params[:unfollow] != "1")
        follower = Follower.where('startup_id = ? AND user_id =?', params[:id], session[:id])[0]
        if !follower
          follower = Follower.new
          follower.startup_id = params[:id]
          follower.user_id = session[:id]
          follower.status = 1
          follower.save
        end
        format.js
      else
        follower = Follower.where('startup_id = ? AND user_id =?', params[:id], session[:id])[0]
        if follower
          follower.destroy
          format.js {render "unfollow_company"}
        end

      end


    end



  end

  def unfollowcompany

    @user = User.find(session[:id])
    @startup = Startup.find(session[:startup_id])

  	if session[:id]==nil || session[:id]==0 
  	  redirect_to :controller => 'users', :action => 'login'
  	else
      @follower = @startup.Followers.find_by_user_id(session[:id])
      @follower.destroy
      redirect_to :controller => 'startups', :action =>'show', :id => session[:startup_id], :shortnotice => 'You were successfully removed from the list of Followers for '+@startup.name
  	end  	
  end


  def add_mentor
    @user = User.find(session[:id])
    @startup = @user.Owner_startups.first
    @follower = Follower.find_by_startup_id_and_user_id(@startup.id,params[:mentor_id])

    if @startup == nil  || @follower == nil
      redirect_to :controller => 'authentications', :action => 'wrong_link'
    end

    respond_to do |format|
      if @follower.update_attributes :status => 2
        format.html { redirect_to controller: 'startups', action: 'show', id: @startup.id}
      else
        format.html { render controller: 'startups', action: 'show', id: @startup.id}
      end
    end

  end

  def delete_mentor
    @user = User.find(session[:id])
    @startup = @user.Owner_startups.first
    @follower = Follower.find_by_startup_id_and_user_id(@startup.id,params[:mentor_id])

    if @startup == nil  || @follower == nil
      redirect_to :controller => 'authentications', :action => 'wrong_link'
    end

    respond_to do |format|
      if @follower.update_attributes :status => 1
        format.html { redirect_to controller: 'startups', action: 'show', id: @startup.id}
      else
        format.html { render controller: 'startups', action: 'show', id: @startup.id}
      end
    end

  end

  
  def people
    @users = User.all
  end

  def search_people
    if !params[:string] || params[:string] == ""
      @people = User.all[0..5]
    else
      s = params[:string].split(" ")
      @people = User.where("(UPPER(firstname) LIKE UPPER(?) and UPPER(lastname) LIKE UPPER(?)) or (UPPER(firstname) LIKE UPPER(?) and UPPER(lastname) LIKE UPPER(?))",
                          "%"+ s[0].to_s()+"%", "%"+ s[1].to_s()+"%", "%"+ s[1].to_s()+"%", "%"+ s[0].to_s()+"%").all[0..5]
    end

    respond_to do |format|
      format.js
    end
  end

  def add_founder

    if !params[:founder_id] || params[:founder_id] == 0
     return
    end

    if User.find(params[:founder_id]) and !Owner.find_by_user_id_and_startup_id(params[:founder_id], params[:id])
      owner = Owner.new
      owner.startup_id = params[:id]
      owner.user_id = params[:founder_id]
      owner.status = 2
      owner.save


      notifications = Notification.where("event_id = ? AND user_id = ? AND status > ? AND (event_type =? OR event_type =?)",
                                         params[:id], params[:founder_id], 0, 1, 2).all

      notifications.each do |notification|
        notification.update_attribute(:status, 0)
      end

      notification  = Notification.new
      notification.event_id = params[:id]
      notification.user_id = params[:founder_id]
      notification.status = 1
      notification.event_type = 1
      notification.save
    end

    respond_to do |format|
        startup = Startup.find(params[:id])
        @people = startup.Owner_users
        format.js
    end

  end

  def remove_founder

    owner = Owner.find_by_user_id_and_startup_id(params[:founder_id], params[:id])

    if !owner
      return
    end


    respond_to do |format|
      if owner.status == 1
        format.js
      else

        notifications = Notification.where("event_id = ? AND user_id = ? AND status > ? AND (event_type =? OR event_type =?)",
                                           params[:id], params[:founder_id], 0, 1, 2).all

        notifications.each do |notification|
          notification.update_attribute(:status, 0)
        end

        notification = Notification.new
        notification.event_id = params[:id]
        notification.user_id = params[:founder_id]
        notification.status = 1
        notification.event_type = 2
        notification.save

        owner.destroy
        startup = Startup.find(params[:id])
        @people = startup.Owner_users
        format.js {render "add_founder"}
      end
    end

  end

  def confirm_founder

    owner = Owner.where("startup_id = ? AND user_id = ?", params[:startup_id], session[:id]).first

    if !owner
      return
    end

    if owner.status == 2
      owner.update_attribute(:status, 3)

      notifications = Notification.where("event_id = ? AND user_id = ? AND status > ? AND event_type =?",
                                         params[:startup_id], session[:id], 0, 1).all
      notifications.each do |notification|
        notification.update_attribute(:status, 0)
      end
      respond_to do |format|
        format.js
      end
    else

    end

  end

  def follower_info

    @follower = User.find(params[:id])
    @startups = @follower.Owner_startups

    respond_to do |format|
      format.js
    end

  end


  def share_with_fund
    if params[:fund_id] and params[:fund_id] != "" and Fund.find(params[:fund_id]) and
            Investor.where("fund_id = ? AND startup_id =? AND connection_type = 1 AND status > 0",
                           params[:fund_id], params[:startup_id]).length == 0
      investor = Investor.new

      investor.fund_id = params[:fund_id]
      investor.startup_id = params[:startup_id]
      investor.user_id = nil
      investor.connection_type = 1
      investor.status = 1

      investor.save
    end

    respond_to do |format|
      @funds = Startup.find(params[:startup_id]).Investor_funds.all
      format.js
    end

  end

  def unshare_with_fund
    if params[:fund_id] and params[:fund_id] != "" and Fund.find(params[:fund_id])
      investors = Investor.where("fund_id = ? AND startup_id =? AND connection_type = 1 AND status > 0",
                       params[:fund_id], params[:startup_id])
      if investors
        investors.destroy_all
      end
    end

    respond_to do |format|
      @funds = Startup.find(params[:startup_id]).Investor_funds.all
      format.js {render "share_with_fund"}
    end

  end


end
  

