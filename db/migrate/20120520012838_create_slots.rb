class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.string :date
      t.string :start_time
      t.string :end_time
      t.boolean :waiting

      t.timestamps
    end
  end
end
