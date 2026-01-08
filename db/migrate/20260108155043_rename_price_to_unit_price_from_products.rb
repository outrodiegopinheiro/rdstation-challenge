class RenamePriceToUnitPriceFromProducts < ActiveRecord::Migration[7.1]
  def change
    rename_column :products, :price, :unit_price
  end
end
