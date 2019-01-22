class ReceiptWorker
  include Sidekiq::Worker
  require 'open-uri'

  def perform(id, sender_email, recipient_email)
    open('/home/vagosdim/Desktop/Bachelor/transfer_smart/receipts/transfer-' + id.to_s + '-receipt.pdf','wb') do |file|
     file << open('http://localhost:3000/transfers/' + id.to_s + '.pdf').read
    end
   
    receipt = File.open("/home/vagosdim/Desktop/Bachelor/transfer_smart/receipts/transfer-" + id.to_s + "-receipt.pdf").read
    UserMailer.sender_email(id, receipt, sender_email).deliver_now
    UserMailer.recipient_email(id, receipt,  recipient_email).deliver_now

  end
end
