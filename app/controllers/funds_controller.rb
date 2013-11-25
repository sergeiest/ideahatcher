class FundsController < ApplicationController
  # GET /funds
  # GET /funds.json

  layout 'general'

  before_filter do
    wrong_link = 0
    case params[:action]
      when "share_with_fund"
        if session[:id] == nil || session[:id] == 0 || session[:startup_id] == nil
          wrong_link = 1
        else
          wrong_link = 1 if Owner.where("startup_id = ? AND user_id", params[:startup_id], params[:id])
        end
      else
        wrong_link = 1 if (session[:id] != 1 and session[:id] != 61 and session[:id] != 62 and session[:id] != 50)
    end

    case wrong_link
      when 1
        redirect_to :controller => 'authentications', :action => 'wrong_link'
      when 2
        render "authentications/join_login_form" and return
    end
  end


  def index
    @funds = Fund.all

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
    @fund = Fund.find(params[:id])

    respond_to do |format|
      if @fund.update_attributes(params[:fund])
        format.html { redirect_to @fund, notice: 'Fund was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fund.errors, status: :unprocessable_entity }
      end
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
