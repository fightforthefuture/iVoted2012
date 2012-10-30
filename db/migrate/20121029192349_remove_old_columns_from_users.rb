class RemoveOldColumnsFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :twitter_id
    remove_column :users, :twitter_name
    remove_column :users, :twitter_screen_name
    remove_column :users, :twitter_active
    remove_column :users, :twitter_oauth_token
    remove_column :users, :twitter_oauth_token_secret
    remove_attachment :users, :avatar
    remove_attachment :users, :badge
    remove_index  :users, :twitter_followers_count
    remove_column :users, :twitter_followers_count
    remove_column :users, :twitter_listed_count
    remove_column :users, :twitter_friends_count
    remove_column :users, :twitter_favourites_count
    remove_column :users, :full_name
    remove_column :users, :show_full_name
    remove_column :users, :follow_us
    rename_column :users, :twitter_badge_style, :badge_type
  end

  def down
    add_column :users,   :twitter_id, :string
    add_column :users,   :twitter_name, :string
    add_column :users,   :twitter_screen_name, :string
    add_column :users,   :twitter_active, :boolean, :default => false
    add_column :users,   :twitter_oauth_token, :string
    add_column :users,   :twitter_oauth_token_secret, :string
    add_attachment :users, :avatar
    add_attachment :users, :badge
    add_column :users, :twitter_followers_count, :integer, :default=> 0
    add_index  :users, :twitter_followers_count
    add_column :users, :twitter_listed_count, :integer, :default=> 0
    add_column :users, :twitter_friends_count, :integer, :default=> 0
    add_column :users, :twitter_favourites_count, :integer, :default=> 0
    add_column :users,   :full_name, :string
    add_column :users, :show_full_name, :boolean, :default=> false
    add_column :users, :follow_us, :boolean, :default=> true
    rename_column :users, :badge_type, :twitter_badge_style
  end
end
