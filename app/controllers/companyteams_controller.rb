class CompanyteamsController < ApplicationController
  # GET /companyteams
  # GET /companyteams.json
  def index
    @startup = Startup.find(session[:startup_id])
    @companyteams = @startup.Companyteams

    @startup_investors = @startup.Investor_users.all.uniq
    @startup_followers = @startup.Follower_users.all.uniq
    @startup_owners = @startup.Owner_users.all.uniq
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @companyteams }
    end
  end

  # GET /companyteams/1
  # GET /companyteams/1.json
  def show
    @companyteam = Companyteam.find(params[:id])
    @startup = Startup.find(session[:startup_id])

    @startup_investors = @startup.Investor_users.all.uniq
    @startup_followers = @startup.Follower_users.all.uniq
    @startup_owners = @startup.Owner_users.all.uniq

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @companyteam }
    end

  end

  # GET /companyteams/new
  # GET /companyteams/new.json
  def new
    @companyteam = Companyteam.new


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @companyteam }
    end
  end

  # GET /companyteams/1/edit
  def edit
    @companyteam = Companyteam.find(params[:id])
  end

  # POST /companyteams
  # POST /companyteams.json
  def create
    @companyteam = Companyteam.new(params[:companyteam])
    @companyteam.startup_id = session[:startup_id]

    respond_to do |format|
      if @companyteam.save
        format.html { redirect_to action: 'index', notice: 'The team member was successfully added.' }
        format.json { render json: @companyteam, status: :created, location: @companyteam }
      else
        format.html { render action: "new" }
        format.json { render json: @companyteam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /companyteams/1
  # PUT /companyteams/1.json
  def update
    @companyteam = Companyteam.find(params[:id])


    respond_to do |format|
      if @companyteam.update_attributes(params[:companyteam])
        format.html { redirect_to action: 'index', notice: 'The update was successful.'  }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @companyteam.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companyteams/1
  # DELETE /companyteams/1.json
  def destroy
    @companyteam = Companyteam.find(params[:id])
    @companyteam.destroy

    respond_to do |format|
      format.html { redirect_to action: 'index', notice: 'The team member was successfully deleted.'  }
      format.json { head :no_content }
    end
  end
end
