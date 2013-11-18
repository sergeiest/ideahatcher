class HomeController < ApplicationController

  layout "general"

  before_filter do
    redirect_to :action => 'index' if !["index", "about", "signup"].include?(params[:action])
  end


  def index
    startups = Startup.where("status >2").all
    @startups = startups.sample(3)
    @tags = Tag.all
  end

  def signup
    startups = Startup.where("status >2").all
    @startups = startups.sample(3)
    @tags = Tag.all
  end


  def about
  
	end

  def colorful
    startups = Startup.where("status >2").all
    @startups = startups.sample(15)
  end
	
end

class Makecount
	def self.make_counter(i=0)
		lambda {i +=1}
	end
end