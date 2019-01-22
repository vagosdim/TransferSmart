class UserMailer < ApplicationMailer
  include SessionsHelper
  
  default from: "transfersmart.developer@gmail.com"
 
  def welcome_email(user)

   @username = user.name
   @url = "https://transfersmart.pagekite.me/login"
   @message = 'whatever you want to say here!'
   mail( :to => user.email, :subject => "Thank you for registration")
    
  end

  def sender_email(id, file, sender)
   
    @message = ""
    attachments["receipt.pdf"] = file
    mail( :to => sender, :subject => "Receipt for your payment")
  end

  def recipient_email(id, file, recipient)
    
    recipient_email = RecipientInfo.find_by(transfer_id: id).email
    @message = PersonalInfo.find_by(transfer_id: id).email
    attachments["receipt.pdf"] = file
    mail( :to => recipient, :subject => "Received money via TransferSmart")
  end

end
