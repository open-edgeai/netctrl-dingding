class AddDdTokenToDdconfig < ActiveRecord::Migration[5.2]
  def change
    add_column :ddconfigs, :DDToken, :string
  end
end
