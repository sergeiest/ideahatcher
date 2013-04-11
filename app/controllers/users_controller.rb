class UsersController < ApplicationController


  layout "main"

  def index
    @user = User.find(params[:id])
    @user_startups = (@user.Owner_startups + @user.Investor_startups + @user.Follower_startups).uniq
    for startup in @user_startups
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

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user }
    end
  end

  def ideas
    @user = User.find(params[:id])  if params[:id] and params[:id]!=0
    @ideas = Idea.where(:is_protected => 0)
    @ideas.sort! { |a, b| [a['title'], a['created_at']] <=> [b['title'], b['created_at']] }
    @ideas.uniq! {|a| a.idea_id}



  end

  def ideas_more
    @user = User.find(params[:id])     if session[:id] and session[:id]!=0
    @ideas = Idea.where(:is_protected => 0)
  end

  def follow
    @user = User.find(params[:id])
    if params[:id]==session[:id].to_s()
      session[:owner_type]=1
    else
      session[:owner_type]=0
    end

    all_startups = @user.Follower_startups

    i=0
    all_startups.each do |startup|
      if startup.Campaign != nil and startup.Campaign.status == 3
        i=i+1
      end
    end

    @startups = Array.new(i)
    @startups_no_capmaign = Array.new(all_startups.length - @startups.length )

    i=0
    k=0

    all_startups.each do |startup|
      if startup.Campaign != nil and startup.Campaign.status == 3
        @startups[i] = startup
        i=i+1
      else
        @startups_no_capmaign[k] = startup
        k=k+1
      end
    end

  end

  def invest
    @user = User.find(params[:id])
    if params[:id]==session[:id].to_s()
      session[:owner_type]=1
    else
      session[:owner_type]=0
    end

    all_startups = @user.Investor_startups

    i=0
    all_startups.each do |startup|
      if startup.Campaign != nil and startup.Campaign.status == 3
        i=i+1
      end
    end

    @startups = Array.new(i)
    @startups_no_capmaign = Array.new(all_startups.length - @startups.length )

    i=0
    k=0

    all_startups.each do |startup|
      if startup.Campaign != nil and startup.Campaign.status == 3
        @startups[i] = startup
        i=i+1
      else
        @startups_no_capmaign[k] = startup
        k=k+1
      end
    end

    @startups.uniq!
    @startups_no_capmaign.uniq!


  end

  def my_account
  end
  
  def show
  end

  
  def edit
    @user = User.find(session[:id])

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
