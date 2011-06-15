class CreateRemoteUsers < ActiveRecord::Migration
  def self.up
    create_table :remote_users do |t|
      t.string :email
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end

  def self.down
    drop_table :remote_users
  end
end
