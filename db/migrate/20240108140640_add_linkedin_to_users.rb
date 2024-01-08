class AddLinkedinToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :linkedin, :string
  end
end
