class NotificationsController < ApplicationController
  # GET /notifications
  # GET /notifications.json


  def check_notification
    user = User.find(session[:id])

    if user
      notifications = Notification.where("user_id = ? AND status = 1", user.id)
      if notifications
        total_notifications = notifications.length
        notification = Notification.find(params[:id])
        if notification
          notification.update_attribute(:status, 0)
          user.update_attribute(:notification_num, total_notifications-1)
        end
        respond_to do |format|
          format.js
        end
      end
    end

  end


  # POST /notifications
  # POST /notifications.json
  def create
    @notification = Notification.new(params[:notification])

    respond_to do |format|
      if @notification.save
        format.html { redirect_to @notification, notice: 'Notification was successfully created.' }
        format.json { render json: @notification, status: :created, location: @notification }
      else
        format.html { render action: "new" }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /notifications/1
  # PUT /notifications/1.json
  def update
    @notification = Notification.find(params[:id])

    respond_to do |format|
      if @notification.update_attributes(params[:notification])
        format.html { redirect_to @notification, notice: 'Notification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy

    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.json { head :no_content }
    end
  end
end
