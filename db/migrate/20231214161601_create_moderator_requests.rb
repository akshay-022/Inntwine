class CreateModeratorRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :moderator_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
