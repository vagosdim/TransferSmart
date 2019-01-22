class HardWorker
  include Sidekiq::Worker
  include WebhooksHelper
  include SessionsHelper

  def perform(transfer_id)
  	t = Transfer.find(transfer_id)
  	webhook = Webhook.find_by(reference: t.reference)
  	find_recipient(t, webhook.endpoint)
  end

end
