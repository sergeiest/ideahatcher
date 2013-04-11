class HomeController < ApplicationController

  layout :layout_by_resource

  def layout_by_resource
    if params[:action] == 'index'
      "home"
    else
      "application"
    end
  end

  before_filter do
    if params[:action] == "index" and (session[:id] != nil and session[:id] != 0)
      redirect_to :controller => 'users', :action => 'ideas', :id => session[:id]
    end
  end


  def index

    @authentication = Authentication.new
    @authentication.username = params[:username]
    @user = @authentication.build_User
    @ideas = Idea.where(:is_protected => 0)

    @ideas.uniq! {|a| a.startup_id}
    @ideas.sort! { |a, b| [a['created_at']] <=> [b['created_at']] }




    campaigns = Campaign.where(:status => 3).first(3)

    @startups = Array.new(campaigns.length)
    i=0
    campaigns.each do |campaign|
      @startups[i] = Startup.find(campaign.startup_id)
      i=i+1
    end
  end
	
	def contacts
  
	end
	
	
	
end

class Makecount
	def self.make_counter(i=0)
		lambda {i +=1}
	end
end