class AddResetToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :reset_digest, :string
    add_column :users, :\, :string
  end
end
