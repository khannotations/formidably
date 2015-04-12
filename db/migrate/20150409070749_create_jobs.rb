class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :cid
      t.string :name
      t.belongs_to :organization
      t.belongs_to :template

      t.timestamps
    end
  end
end
