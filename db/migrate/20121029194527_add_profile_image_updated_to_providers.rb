class AddProfileImageUpdatedToProviders < ActiveRecord::Migration
  def up
    add_column :providers, :profile_image_url, :string
  end
  def down
    remove_column :providers, :profile_image_url
  end
end
