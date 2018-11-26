class CreateThumbnails < ActiveRecord::Migration[5.2]
  def change
    create_table :thumbnails do |t|
      t.string :images
      t.references :task, foreign_key: true

      t.timestamps
    end
  end
end
