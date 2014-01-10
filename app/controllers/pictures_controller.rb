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

  def edit_picture
    startup = Startup.find_by_id(params[:startup_id])
    picture = startup.pictures.find_by_status(params[:picture_status])
    if not picture.nil?
      picture.update_attributes(:description => params[:pic_description], :title => params[:pic_title])
      if not params[:avatar].nil?
        picture.update_attributes(:avatar => params[:avatar])
      end

      redirect_to :controller => "startups", :action => "dashboard", :id => picture.startup_id
    end
  end

  def delete_picture
    startup = Startup.find_by_id(params[:startup_id])
    picture = startup.pictures.find_by_status(params[:picture_status])
    if not picture.nil?
      status = picture.status
      picture.destroy
      
      startup.pictures.each do |each|
        if each.status > status
          each.status = each.status - 1
        end
      end
    end



    redirect_to :controller => "startups", :action => "dashboard", :id => picture.startup_id
  end

end
