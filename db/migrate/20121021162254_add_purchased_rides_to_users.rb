class AddPurchasedRidesToUsers < ActiveRecord::Migration
  def up
    add_column :users, :purchased_rides, :integer
  end

  def down
    remove_column :users, :purchased_rides
  end
end
