class AddConfirmedToSparklyPasswords < ActiveRecord::Migration
  def self.up
    add_column :passwords, :confirmed, :boolean
  end

  def self.down
    remove_column :passwords, :confirmed
  end
end
