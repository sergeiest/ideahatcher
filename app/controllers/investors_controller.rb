class InvestorsController < ApplicationController
  # GET /investors
  # GET /investors.json


  layout :layout_by_resource

  def layout_by_resource
    case params[:action]
      when 'new'
        "main"
      else
        "application"
    end
  end

  def index

  end

  # GET /investors/1
  # GET /investors/1.json
  def show
    @investor = Investor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @investor }
    end
  end

  # GET /investors/new
  # GET /investors/new.json
  def new
    @user = User.find(session[:id]) if session[:id] and session[:id] != 0
    @startup = Startup.find(session[:startup_id])
    @investor = Investor.new
    @startup_investors = @startup.Investor_users.all.uniq
    @startup_followers = @startup.Follower_users.all.uniq
    @startup_owners = @startup.Owner_users.all.uniq

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @investor }
    end
  end

  # GET /investors/1/edit
  def edit
    @investor = Investor.find(params[:id])
  end

  # POST /investors
  # POST /investors.json
  def create
    @investor = Investor.new(params[:investor])
    @investor.user_id=session[:id]
    @investor.startup_id = session[:startup_id]

    @startup = Startup.find(session[:startup_id])
    @campaign = @startup.Campaign

   if @investor.sum != nil && @investor.save
    @campaign.raised_sum = @campaign.raised_sum + @investor.sum
   end

    respond_to do |format|
      if @investor.save
        @campaign.update_attributes(params[:campaign])
        format.html {redirect_to :controller =>'startups', :action =>'show', :id =>  @investor.startup_id}#, :raised_sum => @startup.raised_sum }
        format.json { render json: @investor, status: :created, location: @investor }
      else
        format.html { render action: "new" }
        format.json { render json: @investor.errors, status: :unprocessable_entity }
      end
    end
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
  
    
  def followcompany

    @user = User.find(session[:id])
    @startup = Startup.find(session[:startup_id])

    if session[:id]==nil || session[:id]==0
      redirect_to :controller => 'users', :action => 'login_join'
    #else
    # if @startup.Investor_users.all.include? @user
    #  @investor=@startup.Investors.find_by_user_id(session[:id])
    else
      @follower = Follower.new
      @follower.startup_id = @startup.id
      @follower.user_id = session[:id]
      @follower.status = 1

    end

    if @follower.save
      session[:startup_id]=nil
      redirect_to :controller => 'startups', :action =>'show', :id => @startup.id, :shortnotice => 'You were successfully added to the list of Followers for '+ @startup.name
    else
      format.html { render action: "new" }
      format.json { render json: @investor.errors, status: :unprocessable_entity }
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

  def history_startup
    @startup = Startup.find(session[:startup_id])
    @investors = @startup.Investor_users
    @startup_investors = @startup.Investor_users.all.uniq
    @startup_followers = @startup.Follower_users.all.uniq
    @startup_owners = @startup.Owner_users.all.uniq
  end
  
  def people
    @users = User.all
  end

end
  

