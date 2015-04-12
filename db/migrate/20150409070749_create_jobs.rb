class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :cid
      t.string :name
      t.string :created # Time created on Captricity
      t.string :started # Time started on Captricity
      t.string :finshed # Time finished on Captricity
      t.belongs_to :organization
      t.belongs_to :template
      t.integer :document_cid # A fast reference to the Captricity template
      # t.belongs_to :batch

      t.timestamps
    end
  end
end
