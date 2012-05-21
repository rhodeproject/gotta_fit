class CreateSlotsUsersTable < ActiveRecord::Migration
  def up
    create_table :slots_users, :id => false do |t|
      t.integer :slot_id
      t.integer :user_id
    end
  end

  def down
    drop_table :slots_users
  end
end
