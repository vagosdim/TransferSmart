class UserMailer < ApplicationMailer
  require 'open-uri'
  
  default from: "transfersmart.developer@gmail.com"
 
  def welcome_email(user)

   @username = user.name
   @url = "https://transfersmart.pagekite.me/login"
   @message = 'whatever you want to say here!'
   mail( :to => user.email, :subject => "Thank you for registration")
    
  end

  def sender_email(transfer_id, user)
  puts "\n\n\n\n\n\n\nDEBUG\n\n\n\n\n\n\n\n"    
   # file = open("https://transfersmart.pagekite.me/transfers/"+transfer_id.to_s+".pdf").read
    @message = ""
    #attachments[] = file
    mail( :to => user.email, :subject => "Receipt for your payment")
  end

  def recipient_email(id, user, file)
    puts "localhost:3000/transfers/"+id.to_s+".pdf"
    #recipient_email = RecipientInfo.find_by(transfer_id: id).email
    #file = open("http://localhost:3000/transfers/"+id.to_s+".pdf").read
    @message = ""#sender_name
    attachments["receipt.pdf"] = file
    mail( :to => 'vagelis.dimoulis@gmail.com', :subject => "Received money via TransferSmart")
  end

end
