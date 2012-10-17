class CreatePosts < ActiveRecord::Migration
  def up
    create_table :posts do |t|
      t.integer :user_id, :null=> false
      t.string :screen_name, :null=> false
      t.text :message, :null=> false
      t.string :platform, :default=> "twitter"
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end