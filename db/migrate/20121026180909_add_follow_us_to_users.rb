class AddFollowUsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :follow_us, :boolean, :default=> true
  end
end
