class AddColumnsToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :datathing, :text
    add_column :posts, :form_link, :string
  end
end
