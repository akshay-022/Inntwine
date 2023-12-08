class CreateConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :connections do |t|
      t.references :followed, null: false, foreign_key: true
      t.references :follower, null: false, foreign_key: true
      t.boolean :mutual

      t.timestamps
    end
  end
end
