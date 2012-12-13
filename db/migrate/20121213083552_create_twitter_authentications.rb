class CreateTwitterAuthentications < ActiveRecord::Migration
  def change
    create_table :twitter_authentications do |t|
      t.integer :user_id
      t.string :uid
      t.string :token
      t.string :secret

      t.timestamps
    end
  end
end
