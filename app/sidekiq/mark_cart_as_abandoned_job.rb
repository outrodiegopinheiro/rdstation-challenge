class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform
    now = Time.zone.now
    delta_time_to_abandon = ENV.fetch("TIME_TO_MARK_AS_ABANDONED_IN_SECONDS", 3 * 60 * 60).to_i.seconds

    Cart.where(status: 'ACTIVE').find_each do |cart|
      next if cart.last_interaction_at.present? && (now - cart.last_interaction_at) <= delta_time_to_abandon

      cart.update(status: 'ABANDONED')
    end
  end
end
