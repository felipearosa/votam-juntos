class AddDescriptionToVotes < ActiveRecord::Migration[7.0]
  def change
    add_column :votes, :description, :string
  end
end
