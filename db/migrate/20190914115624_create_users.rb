class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :phone
      t.text :location
      t.text :bio
      t.text :avatar

      t.timestamps
    end
  end
end
