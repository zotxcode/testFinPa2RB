class AddColumnUrlToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :url, :string
  end
end
