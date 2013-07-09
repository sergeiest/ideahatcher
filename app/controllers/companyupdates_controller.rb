class CompanyupdatesController < ApplicationController



  # POST /companyupdates
  # POST /companyupdates.json
  def create
  
    @companyupdate = Companyupdate.new(params[:companyupdate])
    @companyupdate.startup_id = session[:startup_id]
    @companyupdate.newsdate = Time.now

    respond_to do |format|
      if @companyupdate.save
        format.html { redirect_to controller: "startups", action: 'show', id: session[:startup_id], notice: 'The news was successfully created.' }
      else
        format.html { render action: "index" }
        format.json { render json: @companyupdate.errors, status: :unprocessable_entity }
      end
    end
  end


end
