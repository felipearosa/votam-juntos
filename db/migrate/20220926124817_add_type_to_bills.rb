class AddTypeToBills < ActiveRecord::Migration[7.0]
  def change
    add_column :bills, :type, :string
  end
end
