class AddPynameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :pyname, :string
    add_index :users, :pyname
  end
end
