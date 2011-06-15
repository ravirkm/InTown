class CreateRemoteRelationships < ActiveRecord::Migration
  def self.up
    create_table :remote_relationships do |t|
      t.integer :remote_user_id
      t.integer :company_id

      t.timestamps
    end
  end

  def self.down
    drop_table :remote_relationships
  end
end
