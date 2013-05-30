class HomeController < ApplicationController

  layout :layout_by_resource

  def layout_by_resource
    case params[:action]
      when 'index'
        "home"
      when 'colorful'
        "hatcher"
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

  def colorful
    startups = Startup.where("status >2").all
    s1 = startups
    s2 = startups
    s3 = startups
    s4 = startups
    s5 = startups
    @startups = s1.concat(s2.concat(s3).concat(s4.concat(s5)))[0..19]

  end
	
	
end

class Makecount
	def self.make_counter(i=0)
		lambda {i +=1}
	end
end