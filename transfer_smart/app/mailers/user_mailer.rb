class UserMailer < ApplicationMailer

  #default from: "transfersmart.developer@gmail.com"
 
  def welcome_email(user)

   @username = "Eirini Kaloudi"
   @url = "localhost:3000"
   @message = 'whatever you want to say here!'
   mail( :to => user.email, :subject => "Thank you for registration")
    
  end

end
