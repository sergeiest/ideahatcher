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

    @user_infos = @user.userinfos

  end

  def profile
    @user = User.find(params[:id])
    @user_infos = @user.userinfos
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
          format.html { redirect_to :action => "signup"}
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
        format.html { redirect_to :action => "signup"}
      end
    end


  end

end
