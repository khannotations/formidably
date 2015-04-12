class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.integer :cid
      t.integer :front_sheet_id
      t.string :name
      t.datetime :captricity_created_at
      t.integer :page_count
      t.string :default_blank_value
      t.boolean :active
      t.boolean :deleted # Already deleted on Captricity

      t.timestamps
    end
  end
end
