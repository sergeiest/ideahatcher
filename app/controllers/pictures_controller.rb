class PicturesController < ApplicationController

  def upload_picture
    picture = Picture.new
    picture.startup_id = params[:startup_id]
    picture.avatar = params[:avatar]
    picture.status = 1
    picture.title = 'new'
    picture.description = "no description"

    if picture.save!
      redirect_to :controller => "startups", :action => "dashboard", :id => picture.startup_id
    end

  end

end
