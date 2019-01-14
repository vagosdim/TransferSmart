class UserMailer < ApplicationMailer

  #default from: "transfersmart.developer@gmail.com"
 
  def welcome_email(user)

   @username = user.name
   @url = "https://transfersmart.pagekite.me/login"
   @message = 'whatever you want to say here!'
   mail( :to => user.email, :subject => "Thank you for registration")
    
  end

end
