class CreateSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :searches do |t|
      t.string :category
      t.text :title
      t.text :url
      t.text :description

      t.timestamps
    end
  end
end
