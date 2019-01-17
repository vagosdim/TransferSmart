class UserMailer < ApplicationMailer

  #default from: "transfersmart.developer@gmail.com"
 
  def welcome_email(user)

   @username = user.name
   @url = "https://transfersmart.pagekite.me/login"
   @message = 'whatever you want to say here!'
   attachments["invoice.pdf"] = "https://transfersmart.pagekite.me/transfers/1.pdf"
   mail( :to => user.email, :subject => "Thank you for registration")
    
  end

end
