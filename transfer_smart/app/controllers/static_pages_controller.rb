class StaticPagesController < ApplicationController
  include SessionsHelper

  def home
  	if logged_in?
  		redirect_to current_user
  	end
  end

  def help

     #UserMailer.sender_email(27, current_user).deliver_later
    file = File.open("/home/vagosdim/Desktop/Bachelor/transfer_smart/tmp/2019-01-21-receipt.pdf").read
     UserMailer.recipient_email(27, current_user, file).deliver_later#(wait: 1.minute)
  end

  def about
  end

  def contact
  end

end
# open('/home/vagosdim/Desktop/Bachelor/transfer_smart/tmp/27.pdf','wb') do |file|
 #    file << open('http://localhost:3000/transfers/27.pdf').read
# end