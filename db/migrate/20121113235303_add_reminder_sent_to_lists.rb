class AddReminderSentToLists < ActiveRecord::Migration
  def up
    add_column :lists, :reminder_sent, :boolean
  end

  def down
    remove_column :lists, :reminder_sent
  end
end
