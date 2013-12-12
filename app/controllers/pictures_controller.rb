class PicturesController < ApplicationController

  def upload_picture
    picture = Picture.new
    startup = Startup.find_by_id(params[:startup_id])
    picture.startup_id = params[:startup_id]

    picture.avatar = params[:avatar]
    picture.status = startup.pictures.length + 1
    if params[:pic_title].empty?
      picture.title = "Picture #{picture.status}"
    else
      picture.title = params[:pic_title]
    end
    if params[:pic_description].empty?
      picture.description = " "
    else
      picture.description = params[:pic_description]
    end

    if picture.save!
      redirect_to :controller => "startups", :action => "dashboard", :id => picture.startup_id
    end

  end

end
