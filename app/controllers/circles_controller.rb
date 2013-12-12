class CirclesController < ApplicationController
  # GET /circles
  # GET /circles.json


  before_filter do
    wrong_link = 0
    case params[:action]

      when "add_circle", "add_person", "remove_person"
        if session[:id] == nil || session[:id] == 0
          wrong_link = 1
        else
          user = User.find(session[:id])
          if user.nil? || params[:startup_id].nil? || Owner.where("startup_id = ? AND user_id = ?", params[:startup_id], session[:id]).length == 0
            wrong_link = 1
          end
        end

      when "send_access_request", "confirm_request"
        wrong_link = 2 if session[:id].nil? || session[:id] == 0 || User.find(session[:id]).nil?

      else
        wrong_link = 1
    end

    if wrong_link == 1
      #redirect_to :controller => 'authentications', :action => 'wrong_link'
    end
    if wrong_link == 2
      render "authentications/join_login_form" and return
    end
  end



  def add_circle
    startup = Startup.find(params[:startup_id])
    respond_to do |format|
      case params[:circle_status]
        when "0"
          circles = startup.circles
          circles.destroy_all
          @people = startup.circle_users[0..39]
          format.js {render "hide_people"}

        when "1"
          circles = startup.circles.where("status > 2")
          circles.destroy_all
          @people = startup.circle_users[0..39]
          format.js

        when "2"
          circles = startup.circles.where("status > 1")
          circles.destroy_all
          User.all.sample(20).each do |user|
            circle = Circle.new
            circle.startup_id = startup.id
            circle.user_id = user.id
            circle.status = 2
            circle.save
          end
          @people = startup.circle_users[0..39]
        format.js

        when "3"
          circle = Circle.new
          circle.startup_id = startup.id
          circle.user_id = 0
          circle.status = 3
          circle.save
          @people = startup.circle_users[0..39]
          format.js   {render "hide_people"}
        else
          @people = startup.circle_users[0..39]
          format.js   {render "hide_people"}
      end

    end
  end

  def add_person
    startup = Startup.find(params[:startup_id])
    return if !params[:user_id]

    if User.find(params[:user_id]) and circle = startup.circles.where("user_id = ?",params[:user_id]).length == 0
      circle = Circle.new
      circle.startup_id = params[:startup_id]
      circle.user_id = params[:user_id]
      circle.status = 1
      circle.save
    end

    respond_to do |format|
      @people = startup.circle_users[0..39]
      format.js {render "add_circle"}
    end
  end

  def remove_person

    return if !params[:user_id]

    startup = Startup.find(params[:startup_id])
    circle = startup.circles.where("user_id = ?",params[:user_id])
    circle.destroy_all if circle.length > 0

    respond_to do |format|
      @people = startup.circle_users[0..39]
      format.js {render "add_circle"}
    end

  end


  def send_access_request

    return if params[:startup_id].nil?
    startup = Startup.find(params[:startup_id])
    return if startup.nil?

    if startup.circles.where("user_id = ?", session[:id]).length == 0
      circle = Circle.new
      circle.startup_id = params[:startup_id]
      circle.user_id = session[:id]
      circle.status = 3 # 3 - request
      circle.save

      if Notification.where("event_type = 3 AND user_id = ? AND event_id = ? AND status = 1", session[:id], (params[:startup_id].to_i + 10000 * session[:id])).length == 0
        notification  = Notification.new
        notification.event_id = (params[:startup_id].to_i + 10000 * session[:id])
        notification.user_id = Owner.where("startup_id = ? AND status = 1", params[:startup_id])[0].user_id
        notification.status = 1
        notification.event_type = 3
        notification.save
      end

    end

    respond_to do |format|
      format.js
    end

  end

  def confirm_request

    circles = Circle.where("user_id = ? AND startup_id = ? AND status = 3", params[:user_id], params[:startup_id])

    return if circles.length == 0

    circles.each do |circle|
      circle.update_attribute(:status, 4)
    end

    notifications = Notification.where("event_type = 3 AND user_id = ? AND event_id = ? AND status = 1", session[:id], (params[:startup_id].to_i + 10000 * params[:user_id].to_i))
    notifications.each do |notification|
      notification.update_attribute(:status, 0)
    end

    if Notification.where("event_type = 4 AND user_id = ? AND event_id = ? AND status = 1", params[:user_id], params[:startup_id]).length == 0
      notification  = Notification.new
      notification.event_id = params[:startup_id]
      notification.user_id = params[:user_id]
      notification.status = 1
      notification.event_type = 4
      notification.save
    end


    respond_to do |format|
        format.js
    end

  end

end
