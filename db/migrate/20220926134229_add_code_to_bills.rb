class AddCodeToBills < ActiveRecord::Migration[7.0]
  def change
    add_column :bills, :code, :string
  end
end
