class UserinfosController < ApplicationController

  def add_experience

    #if params[:user_id] != session[:id]
    #  redirect_to :controller => "tri_valley_meetup", :action => "signup" and return
    #end

    user_info = Userinfo.new

    user_info.user_id = params[:user_id]
    user_info.category_type = params[:category_type]
    user_info.content = params[:content]
    user_info.status = 1
    user_info.is_main = 0

    user_info.save

    @user = User.find(session[:id])
    @user_infos = @user.userinfos.select{|x| x.status == 1}

    respond_to do |format|
      format.js
    end

  end

  def add_ask

    #if params[:user_id] != session[:id]
    #  redirect_to :controller => "tri_valley_meetup", :action => "signup" and return
    #end

    user_info = Userinfo.new

    user_info.user_id = params[:user_id]
    user_info.category_type = params[:category_type]
    user_info.content = params[:content]
    user_info.status = 2
    user_info.is_main = 0

    user_info.save

    @user = User.find(session[:id])
    @user_infos = @user.userinfos.select{|x| x.status == 2}

    respond_to do |format|
      format.js
    end

  end

end