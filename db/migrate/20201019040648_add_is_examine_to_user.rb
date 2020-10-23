class AddIsExamineToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :isExamine, :boolean
  end
end
