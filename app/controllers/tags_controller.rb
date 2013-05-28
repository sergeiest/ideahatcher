class TagsController < ApplicationController

  before_filter do
    wrong_link = 0
    if session[:id] == nil || session[:id] == 0
      wrong_link = 1
    else
      case params[:action]
        when "add_tag", "delete_tag"
          user = User.find(session[:id])
          session[:startup_id] = user.Owner_startups.first.id
        else
          wrong_link = 1
      end
    end

    if wrong_link == 1
      redirect_to :controller => 'authentications', :action => 'wrong_link'
    end

  end


  def add_tag
    startup = Startup.find(session[:startup_id])
    if params[:tag_name] and params[:tag_name].length.between?(1, 40)
      text = params[:tag_name].downcase.split.join('')
      tag = startup.Tags.find_by_name(text)
      if !tag
        tag = Tag.new
        tag.name = text
        tag.startup_id = startup.id
        tag.save
      end
    end
    @tags = startup.Tags
    respond_to do |format|
      format.js
    end
  end

  def delete_tag
    startup = Startup.find(session[:startup_id])
    if params[:tag_id]
      tag = startup.Tags.find(params[:tag_id])
      tag.destroy
    end
    @tags = startup.Tags
    respond_to do |format|
      format.js { render "add_tag" }
    end
  end


  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to tags_url }
      format.json { head :no_content }
    end
  end
end
