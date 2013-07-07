class LikesController < ApplicationController
  # GET /likes
  # GET /likes.json

  before_filter do
    wrong_link = 0
    case params[:action]
      when "vote"
        wrong_link = 2 if session[:id] == nil || session[:id] == 0
    end

    case wrong_link
      when 1
        redirect_to :controller => 'authentications', :action => 'wrong_link'
      when 2
        render "authentications/join_login_form" and return
    end
  end




  def vote
    add_likes = Like.where("companydescription_id = ? AND user_id = ?", params[:description_id], session[:id])
    if !add_likes || add_likes.length == 0

      add_description = Companydescription.find(params[:description_id])

      add_like = Like.new
      add_like.companydescription_id = params[:description_id]
      add_like.user_id = session[:id]
      add_like.save

      @new_status = add_description.approval_status
      @new_status = 0 if !@new_status
      @new_status += 1
      add_description.update_attribute(:approval_status, @new_status)



      if params[:add_vote] == "1"
        remove_description = Companydescription.find(add_description.companydescription_id)
      else
        remove_description = Companydescription.where("companydescription_id = ?", add_description.id).first
      end

      remove_likes = Like.where("companydescription_id = ? AND user_id = ?", remove_description.id, session[:id])

      if remove_likes and remove_likes.length > 0
        remove_likes.destroy_all
        @old_status = remove_description.approval_status
        @old_status = 0 if !@old_status
        @old_status -= 1
        @old_status = 0 if @old_status < 0
        remove_description.update_attribute(:approval_status, @old_status)
      end

      if params[:add_vote] == "1"
        @p_id = add_description.id
      else
        @p_id = remove_description.id if remove_description
        @old_status = @old_status + @new_status
        @new_status = @old_status - @new_status
        @old_status = @old_status - @new_status
      end

    end
  end



  def index
    @likes = Like.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @likes }
    end
  end

  # GET /likes/1
  # GET /likes/1.json
  def show
    @like = Like.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @like }
    end
  end

  # GET /likes/new
  # GET /likes/new.json
  def new
    @like = Like.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @like }
    end
  end

  # GET /likes/1/edit
  def edit
    @like = Like.find(params[:id])
  end

  # POST /likes
  # POST /likes.json
  def create
    @like = Like.new(params[:like])

    respond_to do |format|
      if @like.save
        format.html { redirect_to @like, notice: 'Like was successfully created.' }
        format.json { render json: @like, status: :created, location: @like }
      else
        format.html { render action: "new" }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /likes/1
  # PUT /likes/1.json
  def update
    @like = Like.find(params[:id])

    respond_to do |format|
      if @like.update_attributes(params[:like])
        format.html { redirect_to @like, notice: 'Like was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /likes/1
  # DELETE /likes/1.json
  def destroy
    @like = Like.find(params[:id])
    @like.destroy

    respond_to do |format|
      format.html { redirect_to likes_url }
      format.json { head :no_content }
    end
  end
end
