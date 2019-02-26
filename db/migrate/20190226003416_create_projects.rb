class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :user_id
      t.string :title
      t.string :description
      t.string :download_link
      t.integer :view_count
      t.string :image_link0
      t.string :image_link1
      t.string :image_link2
      t.string :image_link3
      t.string :image_link4

      t.timestamps null: false
    end
  end
end
