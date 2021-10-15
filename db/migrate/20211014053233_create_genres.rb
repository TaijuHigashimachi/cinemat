class CreateGenres < ActiveRecord::Migration[6.0]
  def change
    create_table :genres do |t|
      t.integer :api_genre_id, null: false, unique: true
      t.string :name, null: false, unique: true

      t.timestamps
    end
  end
end
