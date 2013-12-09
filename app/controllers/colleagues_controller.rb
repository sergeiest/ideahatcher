class ColleaguesController < ApplicationController
	
	before_filter do
	    wrong_link = 0
	    case params[:action]
	   		when "join_fund"
		        if session[:id] == nil || session[:id] == 0 || params[:fund_id] == nil
		          wrong_link = 1
		      	end
		end
	    case wrong_link
	      when 1
	        redirect_to :controller => 'authentications', :action => 'wrong_link'
	      when 2
	        render "authentications/join_login_form" and return
		end
	end


	def join_fund
	    if params[:fund_id] and params[:fund_id] != "" and Fund.find(params[:fund_id]) and
	            Colleague.where("fund_id = ? AND user_id =?",
	                           params[:fund_id], params[:user_id]).length == 0
	      colleague = Colleague.new

	      colleague.fund_id = params[:fund_id]
	      colleague.user_id = params[:user_id]
	      colleague.status = 1

	      colleague.save

		  respond_to do |format|
			@funds = User.find(params[:user_id]).funds
			format.js
    	  end
    	end
  	end

  def unjoin_fund
    if params[:fund_id] and params[:fund_id] != "" and Fund.find(params[:fund_id])
      colleague = Colleague.where("fund_id = ? AND user_id =?",
                       params[:fund_id], params[:user_id])
     	if colleague
        	colleague.destroy_all
    	end
  	end

    respond_to do |format|
      @funds = User.find(params[:user_id]).funds
      format.js {render "join_fund"}
    end
   end
end
