class CreatePhotos < ActiveRecord::Migration
  def up
    create_table :photos do |t|
      t.integer :user_id
      t.string  :provider_type
      t.integer :provider_id
      t.string  :provider_uuid
      t.string  :badge_type
      t.boolean :uploaded
      t.timestamps
    end
    add_attachment :photos, :avatar
    add_attachment :photos, :badge
  end

  def down
     drop_table :photos
  end
end
