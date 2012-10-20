class AddFollowersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_followers_count, :integer, :default=> 0
    add_column :users, :twitter_listed_count, :integer, :default=> 0
    add_column :users, :twitter_friends_count, :integer, :default=> 0
    add_column :users, :twitter_favourites_count, :integer, :default=> 0
    add_column :users, :i_voted_for_president, :string
    add_column :users, :i_voted_because, :string
    add_column :users, :where_i_voted_at, :string

    add_index :users, :twitter_followers_count
    add_index :users, :twitter_badge_style
    change_column :users, :twitter_badge_style, :string, :null => false, :default => "original"
  end
 end
