class ChangeColumnsToText < ActiveRecord::Migration
  def change
     change_column :providers, :description, :text
     change_column :providers, :profile_image_url, :text
     change_column :providers, :profile_background_image_url, :text
  end
end
