class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.string :description
      t.string :extra_information

      t.timestamps
    end
  end
end
