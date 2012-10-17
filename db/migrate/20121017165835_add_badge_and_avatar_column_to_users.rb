class AddBadgeAndAvatarColumnToUsers < ActiveRecord::Migration
  def self.up
    add_attachment :users, :avatar
    add_attachment :users, :badge
  end

  def self.down
    remove_attachment :users, :avatar
    remove_attachment :users, :badge
  end
end