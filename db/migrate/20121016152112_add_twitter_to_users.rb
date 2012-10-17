class AddTwitterToUsers < ActiveRecord::Migration
  def up
     change_table :users do |t|
       t.string   :twitter_id
       t.string   :twitter_name
       t.string   :twitter_screen_name
       t.boolean  :twitter_active, :default => false
       t.string   :twitter_oauth_token
       t.string   :twitter_oauth_token_secret
       t.string   :twitter_badge_style
     end
  end
  def down
    remove_column :users, :twitter_id
    remove_column :users, :twitter_name
    remove_column :users, :twitter_screen_name
    remove_column :users, :twitter_active
    remove_column :users, :twitter_oauth_token
    remove_column :users, :twitter_oauth_token_secret
    remove_column :users, :twitter_badge_style
  end
end
