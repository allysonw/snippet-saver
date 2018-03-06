class CreateLabels < ActiveRecord::Migration[5.1]
  def change
    create_table :labels do |t|
      t.text :name
      t.text :color
      t.timestamps null: false
    end
  end
end
