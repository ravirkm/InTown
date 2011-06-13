class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :company_id
      t.string :date
      t.string :address

      t.timestamps
    end
    add_index :events, :date
  end

  def self.down
    drop_table :events
  end
end
