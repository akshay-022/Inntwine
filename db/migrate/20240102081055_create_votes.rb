class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.integer :question_id
      t.integer :option_id
      
      t.timestamps
    end
  end
end
