class AddVotedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pledged, :boolean, :default=> false
    add_column :users, :voted, :boolean, :default=> false
  end
end