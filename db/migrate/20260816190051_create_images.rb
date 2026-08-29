class CreateImages < ActiveRecord::Migration[8.1]
  def change
    create_table :images do |t|
      t.string :name, null: false
      t.string :mimetype
      t.string :web_address, null: false

      t.timestamps
    end
  end
end
