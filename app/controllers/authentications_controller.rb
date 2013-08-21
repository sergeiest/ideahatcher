class AuthenticationsController < ApplicationController

  layout "hatcher"


  def login
    @authentication = Authentication.new
    @authentication.username = params[:username]
  end

  def login_join
    @authentication = Authentication.new
    @authentication.username = params[:username]
    @user = @authentication.build_User
  end


  def process_login
    if authentication = Authentication.authenticate(params[:authentication])
      params.delete :authentication
      session[:id]=authentication.User.id
      if params[:gotoaction]!= nil and params[:gotocontroller] != nil
        go_to_controller = params[:gotocontroller]
        go_to_action = params[:gotoaction]
        params.delete :gotocontroller
        params.delete :gotoaction
        params.delete :commit
        params.delete :utf8
        params.delete :authenticity_token
        redirect_to  params.merge(:controller => go_to_controller, :action => go_to_action)
      else
        redirect_to  :controller => 'users', :action =>'index', :id => session[:id]
      end
    else
      flash[:error] = 'Invalid email/password combination'
      respond_to do |format|
        params.delete :commit
        params.delete :utf8
        params.delete :authenticity_token
        format.html { render params.merge(:action => 'login') }
      end
    end
  end

  def wrong_link
    id=session[:id]
    reset_session
    session[:id]=id
  end


  def forgot_password
     if params[:email] != nil
       email = params[:email][:address]
       if params[:email][:address] =~ /[a-z0-9!\#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!\#$%\&'\*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum|li|ru|io|co)/i
         authentication = Authentication.find_by_username(email)
         if authentication != nil
           password = Authentication.random_string(10)
           authentication.make_hash(password)
           authentication.update_attributes! :password => authentication.password
           UserMailer.send_password(authentication, password).deliver
         end
       end

     end
  end

  def logout
    reset_session
    # ---------------- Demo -----------------
    session[:id]=0 
    # ---------------- End demo -----------------
    flash[:message] = 'Logged out'
    redirect_to :controller => 'home', :action => 'index'
  end
  
    
  def checklogin
    if session[:id]!=nil and session[:id]!=0
      go_to_controller = params[:gotocontroller]
      go_to_action = params[:gotoaction]
      params.delete :gotocontroller
      params.delete :gotoaction
      params.delete :commit
      params.delete :utf8
      params.delete :authenticity_token
      redirect_to  params.merge(:controller => go_to_controller, :action => go_to_action)
    else
      @authentication = Authentication.new
      redirect_to params.merge(:action => 'index', :controller => 'home')
    end
  end
  
  def new

    @authentication = Authentication.new
    @user = @authentication.build_User

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  def create

    @authentication = Authentication.new(params[:authentication])
    @authentication.make_username(params[:authentication][:username])

    user_errors = User.check_errors(params[:user])
    authentication_errors = Authentication.check_errors(params[:authentication])

    if user_errors == nil and authentication_errors == nil and @authentication.password == params[:ll][:password_confirmation]

      @authentication.make_hash(params[:authentication][:password])
      @user = @authentication.create_User(params[:user])

      startup_id = session[:startup_id]
      reset_session
      session[:startup_id] = startup_id

      respond_to do |format|
        if @authentication.save
          session[:id]=@user.id

          if params[:gotoaction]!= nil and params[:gotocontroller] != nil
            format.html { redirect_to controller: params[:gotocontroller], action: params[:gotoaction]}
          else
            format.html { redirect_to controller: 'startups', action: 'index'}
            format.js { render "remote_login"}
          end
        else
          format.html { render action: "new", gotocontroller: params[:gotocontroller], gotoaction: params[:gotoaction]}
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end

    else
      respond_to do |format|
        @user = User.new(params[:user])
        @user.errors.add user_errors.partition("/")[0]  , user_errors.partition("/")[2] if user_errors != nil
        if authentication_errors != nil
          @authentication.errors.add authentication_errors.partition("/")[0]  , authentication_errors.partition("/")[2]
        end
        if @authentication.password != params[:ll][:password_confirmation]
          @authentication.errors.add :password, "Passwords do not match"
        end
        format.html { render action: "new", gotocontroller: params[:gotocontroller], gotoaction: params[:gotoaction]}
        format.json { render json: @user.errors, status: :unprocessable_entity}
      end
    end

 end



  def update_password
    if params[:new][:password] != params[:new][:confirm_password] || !params[:new][:password].length.between?(3, 60)
      flash[:error] = 'Passwords do not match'
      redirect_to :controller => 'users', :action => 'change_password'
      return
    end

    user = User.find(session[:id])
    new_authentication = Authentication.new
    new_authentication.username = Authentication.find(user.authentication_id).username
    new_authentication.password = params[:old][:password]

    if !authentication = Authentication.authenticate(new_authentication)
      flash[:error] = 'Wrong old password'
      redirect_to :controller => 'users', :action => 'change_password'
      return
    end

    authentication.make_hash(params[:new][:password])
    if authentication.update_attributes :password => authentication.password
        redirect_to :controller => 'users', :action => 'index', :id => session[:id]
    else
        flash[:error] = 'Could not update password'
        redirect_to :controller => 'users', :action => 'change_password'
    end

  end


  def remote_login
    if authentication = Authentication.authenticate(params[:authentication])
      session[:id]=authentication.User.id
      @user = User.find(session[:id])
      respond_to do |format|
        format.js
      end
    else
      flash[:error] = 'Invalid email/password combination'
      respond_to do |format|
        format.js { render "wrong_login" }
      end
    end

  end

end
