class AddDescriptionToSlots < ActiveRecord::Migration
  def up
    add_column :slots, :description, :string
  end

  def down
    remove_column :slots, :description
  end
end
