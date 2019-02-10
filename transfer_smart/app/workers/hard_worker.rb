class HardWorker
  include Sidekiq::Worker
  include WebhooksHelper
  include SessionsHelper
  require 'open-uri'

  def perform(id)
  	transfer = Transfer.find(id)
  	webhook = Webhook.find_by(reference: transfer.reference)
  	if(webhook)
  		find_recipient(transfer, webhook.endpoint)
  		sender = PersonalInfo.find(transfer.personal_info_id)
	  	sender_email = sender.email
	  	recipient_email = RecipientInfo.find(transfer.recipient_info_id).email
	  	message = sender.first_name + sender.last_name

	  	open('/home/vagosdim/Desktop/Bachelor/transfer_smart/receipts/transfer-' + id.to_s + '-receipt.pdf','wb') do |file|
	     file << open('http://localhost:3000/transfers/' + id.to_s + '.pdf').read
	    end
	   
	    receipt = File.open("/home/vagosdim/Desktop/Bachelor/transfer_smart/receipts/transfer-" + id.to_s + "-receipt.pdf").read
	    UserMailer.sender_email(id, receipt, sender_email).deliver_now
	    UserMailer.recipient_email(id, receipt,  recipient_email, message).deliver_now
	end
  end

end
