class AddDdTokenCreatedAtToDdconfig < ActiveRecord::Migration[5.2]
  def change
    add_column :ddconfigs, :DDTokenCreatedAt, :datetime
  end
end
