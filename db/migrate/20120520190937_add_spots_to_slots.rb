class AddSpotsToSlots < ActiveRecord::Migration
  def change
    add_column  :slots, :spots, :integer
  end
end
