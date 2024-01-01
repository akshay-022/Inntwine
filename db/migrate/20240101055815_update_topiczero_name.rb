class UpdateTopiczeroName < ActiveRecord::Migration[7.0]
  def change
    Topic.find_by(id: 0)&.update(topic_name: "All Public Posts")
  end
end
