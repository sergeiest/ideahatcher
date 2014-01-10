class TriValleyMeetupController < ApplicationController

  layout "tri_valley"

  before_filter do
    case params[:action]
      when "show", "update_profile"
        if session[:id].nil? || session[:id] == 0
          redirect_to :action => 'signup' and return
        end
      when "profile"
        if session[:id].nil? || session[:id] == 0 || params[:id].nil?
          redirect_to :action => 'signup' and return
        end

        if session[:id].to_s == params[:id]
          redirect_to :action => 'update_profile' and return
        end

        user = User.find(params[:id])
        if user.nil? || Colleague.where("user_id = ? and fund_id =?", params[:id], Fund.find_by_hashtag('trivalley').id).length == 0
          redirect_to :action => 'signup' and return
        end
    end
  end


  def signup

  end

  def show
    fund = Fund.find_by_hashtag('trivalley')
    @people = fund.users
    @people.sort! {|x, y| x["firstname"] <=> y["firstname"]}

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

end
