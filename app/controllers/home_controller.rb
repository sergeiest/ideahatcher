class HomeController < ApplicationController

  layout "hatcher"

  before_filter do
    redirect_to :action => 'colorful' if !["colorful","about"].include?(params[:action])
  end


  def index
    redirect_to :action => "colorful" and return
  end
	
	def about
  
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