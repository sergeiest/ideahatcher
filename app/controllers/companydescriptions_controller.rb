class CompanydescriptionsController < ApplicationController


  # GET /companydescriptions/new
  # GET /companydescriptions/new.json
  def new
    @companydescription = Companydescription.new
    @startup = Startup.find(session[:startup_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @companydescription }
    end
  end

  # GET /companydescriptions/1/edit
  def edit
    @companydescription = Companydescription.find(params[:id])
  end

  def new_suggestion

    old_description = Companydescription.find(params[:companydescription][:companydescription_id])
    @description = Companydescription.new(params[:companydescription])
    @description.startup_id = old_description.startup_id
    @description.allfield_id = old_description.allfield_id
    @description.field_status = old_description.field_status
    @description.status = 1

    respond_to do |format|
      if @description.save
        old_description.update_attribute(:status, 0)
        format.html { redirect_to controller: "campaigns" }
        format.json { head :no_content }
        format.js
      else
        format.html { redirect_to controller: "campaigns"}
        format.json { render json: @companydescription.errors, status: :unprocessable_entity }
        format.js
      end
    end

  end

  # POST /companydescriptions
  # POST /companydescriptions.json
  def create

    @companydescription = Companydescription.new(params[:companydescription])
    @companydescription.startup_id = session[:startup_id]
    @companydescription.approval_status = 1
    @companydescription.status = 1


    case params[:route]
      when "campaign" then
        respond_to do |format|
          if @companydescription.save
            format.html { redirect_to action: 'secondstep', controller: "campaigns" }
            format.json { head :no_content }
          else
            format.html { redirect_to action: 'secondstep', controller: "campaigns"}
            format.json { render json: @companydescription.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          if @companydescription.save
            format.html { redirect_to action: 'index', notice: 'The info was successfully created.' }
            format.json { render json: @companydescription, status: :created, location: @companydescription }
          else
            format.html { render action: "new" }
            format.json { render json: @companydescription.errors, status: :unprocessable_entity }
          end
        end
    end

  end

  # PUT /companydescriptions/1
  # PUT /companydescriptions/1.json
  def update
    @companydescription = Companydescription.find(params[:id])

    respond_to do |format|

      case params[:route]
        when "campaign" then
          if @companydescription.update_attributes(params[:companydescription])
            format.html { redirect_to action: 'secondstep', controller: "campaigns"}
            format.json { head :no_content }
          else
            format.html { redirect_to action: 'secondstep', controller: "campaigns"}
            format.json { render json: @companydescription.errors, status: :unprocessable_entity }
          end

        when "funds" then
          if @companydescription.update_attributes(params[:companydescription])
            format.html { redirect_to controller: 'funds', action: 'approval'}
            format.json { head :no_content }
          else
            format.html { redirect_to controller: 'funds', action: 'approval'}
            format.json { render json: @companydescription.errors, status: :unprocessable_entity }
          end

        else
          if @companydescription.update_attributes(params[:companydescription])
            format.html { redirect_to action: 'index', notice: 'The info was successfully created.'}
            format.json { head :no_content }
          else
            format.html { render action: "edit" }
            format.json { render json: @companydescription.errors, status: :unprocessable_entity }
          end
      end
    end
  end

  def update_description
    @companydescription = Companydescription.find(params[:description][:id])
    @companydescription.update_attributes(params[:description])
    respond_to do |format|
      format.js
    end
  end


  # DELETE /companydescriptions/1
  # DELETE /companydescriptions/1.json
  def destroy
    @companydescription = Companydescription.find(params[:id])

    @companydescription.destroy

    respond_to do |format|
      format.html { redirect_to action: 'index', notice: 'The info was successfully deleted.' }
      format.json { head :no_content }
    end
  end

end
