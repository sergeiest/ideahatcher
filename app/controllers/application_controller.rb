class ApplicationController < ActionController::Base
  protect_from_forgery
  
  #before_filter do
  #  if session[:id] == nil and (params[:controller]+params[:action] != 'homedemo' and params[:controller]+params[:action] != 'authenticationsdemo_login')
  #      redirect_to :controller => 'home', :action => 'demo'
  #  end
  #end
  
  layout :layout_by_resource

  def layout_by_resource
    if params[:controller]+params[:action] =='homedemo'
      "demo"
    else
      "application"
    end
  end
  
end


class String

  def firstletters(nletters)
    if self.size > nletters
      a = self[0...nletters-2].rindex(' ')
      if a != nil
        self[0...Integer(a)]+'..'
      else
        self[0...nletters]+'..'
      end
    else
      self
    end
  end
  
end

