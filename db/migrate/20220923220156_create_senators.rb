class CreateSenators < ActiveRecord::Migration[7.0]
  def change
    create_table :senators do |t|
      t.string :name
      t.string :party
      t.integer :senate_key

      t.timestamps
    end
  end
end
