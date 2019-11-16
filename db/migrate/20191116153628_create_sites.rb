class CreateSites < ActiveRecord::Migration[6.0]
  def change
    create_table :sites do |t|
      t.string :name
      t.string :text
      t.string :url
      t.string :screenshot
      t.string :preview_screenshot
      t.timestamps
    end
  end
end
