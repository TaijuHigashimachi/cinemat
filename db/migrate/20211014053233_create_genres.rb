class CreateGenres < ActiveRecord::Migration[6.0]
  def change
    create_table :genres do |t|
      t.integer :api_genre_id, null: false
      t.string :name, null: false, unique: true

      t.timestamps
    end

    add_index :genres, :name, unique: true
  end
end
