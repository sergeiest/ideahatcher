class UserinfosController < ApplicationController

  def add_experience

    user_info = Userinfo.new

    user_info.user_id = params[:user_id]
    user_info.category_type = params[:category_type]
    user_info.content = params[:content]
    user_info.status = 1
    user_info.is_main = 0

    user_info.save

    respond_to do |format|
      format.js
    end

  end

  def add_ask

    user_info = Userinfo.new

    user_info.user_id = params[:user_id]
    user_info.category_type = params[:category_type]
    user_info.content = params[:content]
    user_info.status = 2
    user_info.is_main = 0

    user_info.save

    respond_to do |format|
      format.js
    end

  end

end
