class AddOwnerUserAndGroupToDirectories < ActiveRecord::Migration
  def self.up
    add_column :directories, :uid, :integer
    add_column :directories, :gid, :integer
  end

  def self.down
    remove_column :directories, :uid
    remove_column :directories, :gid
  end
end
