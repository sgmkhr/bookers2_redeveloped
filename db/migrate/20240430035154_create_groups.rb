class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :owner_id
      t.text :introduction

      t.timestamps
    end
  end
end
