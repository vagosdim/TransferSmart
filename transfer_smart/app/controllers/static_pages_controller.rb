class StaticPagesController < ApplicationController
  include SessionsHelper

  def home
  	if logged_in?
  		redirect_to current_user
  	end
  end

  def help
  end

  def about
  end

end

