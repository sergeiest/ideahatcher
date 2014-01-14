class TriValleyMeetupController < ApplicationController

  layout "tri_valley"

  before_filter do
    case params[:action]
      when "show", "update_profile"
        if session[:id].nil? || session[:id] == 0
          redirect_to :action => 'signup' and return
        end

        user = User.find(session[:id])
        if user.nil? || Colleague.where("user_id = ? and fund_id =?", session[:id], Fund.find_by_hashtag('trivalley').id).length == 0
          redirect_to :action => 'add_to_fund' and return
        end

      when "profile"
        if session[:id].nil? || session[:id] == 0 || params[:id].nil?
          redirect_to :action => 'signup' and return
        end

        user = User.find(params[:id])
        if user.nil? || Colleague.where("user_id = ? and fund_id =?", params[:id], Fund.find_by_hashtag('trivalley').id).length == 0
          redirect_to :action => 'add_to_fund' and return
        end

        if session[:id].to_s == params[:id]
          redirect_to :action => 'update_profile' and return
        end

      when "update_profile"
        if session[:id].nil? || session[:id] == 0
          redirect_to :action => 'signup' and return
        end

      when "admin_view", "send_email"
        if session[:id] != 1
          redirect_to :action => 'signup' and return
        end

    end
  end


  def signup

    @authentication = nil
    @user = nil

  end

  def show
    fund = Fund.find_by_hashtag('trivalley')
    @people = fund.users
    @people.sort! {|x, y| x["firstname"] <=> y["firstname"]}

  end

  def add_to_fund
    @user = User.find(session[:id])
  end

  def update_profile
    @user = User.find(session[:id])

    @list_of_skills = ""
    @list_of_skills += "<option>Business</option>"
    @list_of_skills += "<option>Design</option>"
    @list_of_skills += "<option>Education</option>"
    @list_of_skills += "<option>Marketing</option>"
    @list_of_skills += "<option>Network</option>"
    @list_of_skills += "<option>Sales</option>"
    @list_of_skills += "<option>Tech</option>"

    @list_of_projects = @user.owner_startups

    @user_infos = @user.userinfos
    @experiences = @user_infos.select{|x| x.status == 1}
    @asks = @user_infos.select{|x| x.status == 2}
    @occupation = @user.userinfos.find_by_status(3)
    @project = @user.userinfos.find_by_status(4)
    if not @project.idea_id.nil?
      puts @project.idea_id
      @chosen_project = @project.idea_id
    end

  end

  def profile
    @user = User.find(params[:id])
    @user_infos = @user.userinfos
    @occupation = @user_infos.find_by_status(3)
    @project = @user_infos.find_by_status(4)
    if not @project.idea_id.nil?
      chosen_project = @project.idea_id
      @startup_link = @user.owner_startups.find(chosen_project)
    end
    @auth = Authentication.find_by_id(@user.authentication_id)
    @email = @auth.username
  end

  def logout
    reset_session
    redirect_to :action => 'signup'
  end

  def login
    if authentication = Authentication.authenticate(params[:authentication])
      session[:id] = authentication.user.id
      @user = User.find(session[:id])

      @notifications = @user.notifications.where("status = 1")
      @user.update_attributes(:notification_num => @notifications.length, :updated_at => Time.now)

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


  def create_account

    @authentication = Authentication.new(params[:authentication])
    @authentication.make_username(params[:authentication][:username])

    user_errors = User.check_errors(params[:user])
    authentication_errors = Authentication.check_errors(params[:authentication])

    if user_errors == nil and authentication_errors == nil and @authentication.password == params[:ll][:password_confirmation]

      @authentication.make_hash(params[:authentication][:password])
      @user = @authentication.create_user(params[:user])

      reset_session

      respond_to do |format|
        if @authentication.save
          session[:id] = @user.id

          colleague = Colleague.new
          colleague.user_id = session[:id]
          colleague.fund_id = Fund.find_by_hashtag('trivalley').id
          colleague.status = 1
          colleague.save

          #UserMailer.send_welcome(params[:authentication][:username], @user.firstname).deliver

          format.html { redirect_to :action => "update_profile"}
        else
          flash[:error] = "Something went wrong. If you see this message again, please contact us"
          format.html { redirect_to :action => "signup"}
        end
      end

    else
      respond_to do |format|

        @user = User.new(params[:user])
        #@user.errors.add user_errors.partition("/")[0]  , user_errors.partition("/")[2] if user_errors != nil
        flash[:error] = user_errors.partition("/")[2] if user_errors != nil

        if authentication_errors != nil
          #@authentication.errors.add authentication_errors.partition("/")[0]  , authentication_errors.partition("/")[2]
          flash[:error] = authentication_errors.partition("/")[2]
        end

        if @authentication.password != params[:ll][:password_confirmation]
          #@authentication.errors.add :password, "Passwords do not match"
          flash[:error] = "Passwords do not match"
        end

        format.html { render :action => "signup"}
      end
    end


  end

  def forgot_password
    if params[:email] != nil
      email = params[:email][:address]
      if params[:email][:address] =~ /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/i
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

  def change_password
    @user = User.find(session[:id])
  end

  def admin_view

  end

  def send_email
    UserMailer.send_welcome_tri_valley(params[:email], params[:name], params[:password]).deliver

    render "admin_view"
  end

end
