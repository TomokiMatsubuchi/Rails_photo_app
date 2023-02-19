class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.string :title, null: false, length: {maximum: 30}
      t.string :description, null: false, length: {maximum: 200}

      t.timestamps
    end
  end
end
