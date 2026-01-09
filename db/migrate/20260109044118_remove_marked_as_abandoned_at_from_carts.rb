class RemoveMarkedAsAbandonedAtFromCarts < ActiveRecord::Migration[7.1]
  def change
    remove_column :carts, :marked_as_abandoned_at, :datetime
  end
end
