class HomeController < ApplicationController

  layout "hatcher"

  before_filter do
    redirect_to :action => 'index' if !["index"].include?(params[:action])
  end


  def index
    startups = Startup.where("status >2").all
    @startups = startups.sample(16)[0..14]
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