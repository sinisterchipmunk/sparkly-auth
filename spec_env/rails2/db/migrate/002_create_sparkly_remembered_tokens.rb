class CreateSparklyRememberedTokens < ActiveRecord::Migration
  def self.up
    create_table :remembrance_tokens do |t|
      t.string :series_token
      t.string :remembrance_token
      
      t.references :authenticatable, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :remembrance_tokens
  end
end
