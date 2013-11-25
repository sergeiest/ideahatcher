class ApplicationController < ActionController::Base

  #before_filter do
  #  if session[:id] == nil and (params[:controller]+params[:action] != 'homedemo' and params[:controller]+params[:action] != 'authenticationsdemo_login')
  #      redirect_to :controller => 'home', :action => 'demo'
  #  end
  #end

  rescue_from ActionController::RoutingError, :with => :render_not_found

  def render_not_found
    render "authentications/wrong_link"
  end

  protect_from_forgery


  layout "general"

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

  def escape_characters_in_string()
    pattern = /(\'|\"|\.|\*|\/|\-|\\)/
    string.gsub(pattern, '\\\0')
  end
  
end

