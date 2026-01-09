class AddMarkedAsAbandonedAtToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :marked_as_abandoned_at, :datetime
  end
end
