class FundsController < ApplicationController
  # GET /funds
  # GET /funds.json

  before_filter do
    if User.find(session[:id]).Funds == nil
      redirect_to :controller => 'home', :action => 'noaccess' and return
    end
  end

  def index
    @funds = Fund.all
    @startups=Startup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @funds }
    end
  end

  # GET /funds/1
  # GET /funds/1.json
  def show
    @fund = Fund.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fund }
    end
  end

  def approval
    if session[:startup_id] == nil
    	session[:startup_id] = params[:startup_id]
    end
    @fund = Fund.find_by_user_id(session[:id])
    @companydescriptions = Companydescription.where("startup_id = ?", session[:startup_id])
    @campaign = Campaign.find_by_startup_id(session[:startup_id])

    respond_to do |format|
      format.html # approval.html.erb
      format.json { render json: @startup }
    end
  end

  # GET /funds/new
  # GET /funds/new.json
  def new
    @fund = Fund.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fund }
    end
  end

  # GET /funds/1/edit
  def edit
    @fund = Fund.find(params[:id])
  end

  # POST /funds
  # POST /funds.json
  def create
    @fund = Fund.new(params[:fund])

    respond_to do |format|
      if @fund.save
        format.html { redirect_to @fund, notice: 'Fund was successfully created.' }
        format.json { render json: @fund, status: :created, location: @fund }
      else
        format.html { render action: "new" }
        format.json { render json: @fund.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /funds/1
  # PUT /funds/1.json
  def update
    @cd = Companydescription.where("startup_id = ? AND allfield_id = ?", session[:startup_id], params[:companydescription].allfield_id)

    respond_to do |format|

      @cd.update_attributes(params[:companydescription])
      format.html { redirect_to controller: 'funds', action: 'approval'}
=begin
      else
        format.html { redirect_to controller: 'funds', action: 'approval'}

        format.html { render action: "edit" }
        format.json { render json: @fund.errors, status: :unprocessable_entity }

    end
=end
    end
  end

# DELETE /funds/1
# DELETE /funds/1.json
  def destroy
    @fund = Fund.find(params[:id])
    @fund.destroy

    respond_to do |format|
      format.html { redirect_to funds_url }
      format.json { head :no_content }
    end
  end
end
