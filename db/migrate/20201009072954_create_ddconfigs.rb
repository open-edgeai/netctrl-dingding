class CreateDdconfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :ddconfigs do |t|
      t.string :CorpId
      t.string :AppKey
      t.string :AppSecret
      t.string :AgentId
      t.string :DDToken
      t.datetime :DDTokenCreatedAt

      t.timestamps
    end
  end
end
