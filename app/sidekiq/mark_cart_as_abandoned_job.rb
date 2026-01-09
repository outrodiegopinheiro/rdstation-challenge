class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform
    now = Time.zone.now
    delta_time_to_abandon = ENV.fetch("TIME_TO_MARK_AS_ABANDONED_IN_SECONDS", 3 * 60 * 60).to_i.seconds

    Cart.where(status: 'ACTIVE').find_each do |cart|
      next if cart.last_interaction_at.present? && (now - cart.last_interaction_at) <= delta_time_to_abandon

      cart.update(status: 'ABANDONED', marked_as_abandoned_at: now)
    end

    ###

    delta_days_to_destroy = ENV.fetch("TIME_TO_DESTROY_ABANDONED_CART_IN_DAYS", 7).to_i.days
    datetime_to_test_to_destroy = now - delta_days_to_destroy

    Cart.where(status: 'ABANDONED', marked_as_abandoned_at: ...datetime_to_test_to_destroy).each(&:destroy)
  end
end
