class VotesController < ApplicationController
  # GET /votes
  # GET /votes.json

  before_filter do
    wrong_link = 0
    case params[:action]
      when "vote_description"
        wrong_link = 2 if session[:id] == nil || session[:id] == 0
    end

    case wrong_link
      when 1
        redirect_to :controller => 'authentications', :action => 'wrong_link'
      when 2
        render "authentications/join_login_form" and return
    end
  end


  def vote_description

    startup_votes = Vote.where("user_id = ? AND startup_id =?", session[:id], params[:startup_id])

    if startup_votes.length == 0
      is_voted = 0
    else
      vote = startup_votes.select{|x| x.companydescription_id.to_s == params[:vote][:description_id]}
      if !vote.nil? and vote.length > 0
        is_voted = 1
      else
        is_voted = 0
      end
    end

    if is_voted == 0
      vote = Vote.new
      vote.companydescription_id = params[:vote][:description_id]
      vote.startup_id = params[:startup_id]
      vote.user_id = session[:id]
      vote.score = params[:vote][:score]
      vote.save
      if startup_votes.length == 0
        startup = Startup.find(params[:startup_id])
        startup.votes = 0 if startup.votes.nil?
        startup.update_attribute(:votes, startup.votes + 1)
      end
    else
      vote[0].update_attribute(:score, params[:vote][:score])
    end

    respond_to do |format|
      format.js
    end
  end

  def show_votes
    @votes = Vote.where("companydescription_id = ?",params[:description_id]).all

  end

  def index
    @votes = Vote.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @votes }
    end
  end

  # GET /votes/1
  # GET /votes/1.json
  def show
    @vote = Vote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vote }
    end
  end

  # GET /votes/new
  # GET /votes/new.json
  def new
    @vote = Vote.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /votes/1/edit
  def edit
    @vote = Vote.find(params[:id])
  end

  # POST /votes
  # POST /votes.json
  def create
    @vote = Vote.new(params[:vote])

    respond_to do |format|
      if @vote.save
        format.html { redirect_to @vote, notice: 'Vote was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.json
  def update
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        format.html { redirect_to @vote, notice: 'Vote was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.json
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to votes_url }
      format.json { head :no_content }
    end
  end
end
