class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.integer :cid
      t.string :name
      t.belongs_to :organization
      t.belongs_to :template
      t.string :status

      t.timestamps
    end
  end
end
