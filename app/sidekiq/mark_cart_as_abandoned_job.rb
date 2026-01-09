class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform
    now = Time.zone.now

    Cart.where(status: 'ACTIVE').each { |cart| cart.mark_as_abandoned(datetime: now) }

    ###

    Cart.where(status: 'ABANDONED').each { |cart| cart.remove_if_abandoned(datetime: now) }
  end
end
