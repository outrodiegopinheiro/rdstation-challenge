require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake! # fake is the default mode

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  describe "#perform_later" do
    it "run" do
      expect {
        MarkCartAsAbandonedJob.perform_async
      }.to change(MarkCartAsAbandonedJob.jobs, :size).by(1)

      MarkCartAsAbandonedJob.drain

      expect(MarkCartAsAbandonedJob.jobs.size).to eq(0)
    end
  end
end
