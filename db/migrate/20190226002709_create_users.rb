class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :profile_pic_link
      t.string :short_bio

      t.timestamps null: false
    end
  end
end
