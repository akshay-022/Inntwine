class CreateCommunities < ActiveRecord::Migration[7.0]
  def change
    create_table :communities do |t|
      t.string :name
      t.text :description
      t.references :organization, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true
      t.references :privacy, null: false, foreign_key: true
      t.references :moderators, null: false, foreign_key: true

      t.timestamps
    end
  end
end
