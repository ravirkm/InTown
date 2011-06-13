class AddRadiusToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :radius, :integer, :default => 30
  end

  def self.down
    remove_column :users, :radius
  end
end
