class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :userid, :unique => true
      t.string :unionid
      t.string :mobile
      t.string :tel
      t.string :workPlace
      t.boolean :isAdmin
      t.boolean :isBoss
      t.string :isLeaderInDepts
      t.string :isSenior
      t.string :name
      t.boolean :active
      t.string :department
      t.string :position
      t.string :avatar
      t.string :ddtoken
      t.boolean :isSurfingNet
      t.boolean :isSurfingControll

      t.timestamps
    end
  end
end
