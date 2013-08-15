class CirclesController < ApplicationController
  # GET /circles
  # GET /circles.json


  before_filter do
    wrong_link = 0
    if session[:id] == nil || session[:id] == 0
      wrong_link = 1
    else
      case params[:action]

        when "add_circle", "add_person", "remove_person"
          user = User.find(session[:id])
          session[:startup_id] = user.Owner_startups.first.id
        else
          wrong_link = 1
      end

    end
    if wrong_link == 1
      #redirect_to :controller => 'authentications', :action => 'wrong_link'
    end
  end



  def add_circle
    startup = Startup.find(session[:startup_id])
    respond_to do |format|
      case params[:circle_status]
        when "0"
          circles = startup.Circles
          circles.destroy_all
          @people = startup.Circle_users[0..9]
          format.js {render "hide_people"}

        when "1"
          @people = startup.Circle_users[0..9]
          format.js

        when "2"
          circles = startup.Circles.where("status = ?",2)
          circles.destroy_all
          User.all.sample(20).each do |user|
            circle = Circle.new
            circle.startup_id = startup.id
            circle.user_id = user.id
            circle.status = 2
            circle.save
          end
          @people = startup.Circle_users[0..9]
        format.js

        when "3"

          circle = Circle.new
          circle.startup_id = startup.id
          circle.user_id = 0
          circle.status = 3
          circle.save
          @people = startup.Circle_users[0..9]
          format.js   {render "hide_people"}
        else
          @people = startup.Circle_users[0..9]
          format.js   {render "hide_people"}
      end

    end
  end

  def add_person
    startup = Startup.find(session[:startup_id])
    if !params[:user_id]
      return
    end

    if User.find(params[:user_id]) and
        Circle.where("user_id = ? AND startup_id = ?",params[:user_id], session[:startup_id]).length == 0
      circle = Circle.new
      circle.startup_id = session[:startup_id]
      circle.user_id = params[:user_id]
      circle.status = 1
      circle.save
    end

    respond_to do |format|
      @people = startup.Circle_users[0..19]
      format.js {render "add_circle"}
    end
  end

  def remove_person
    startup = Startup.find(session[:startup_id])
    if !params[:user_id]
      return
    end
    circle = Circle.find_by_user_id(params[:user_id])
    if circle and User.find(params[:user_id])
      circle.destroy
    end
    respond_to do |format|
      @people = startup.Circle_users[0..19]
      format.js {render "add_circle"}
    end
  end


end
