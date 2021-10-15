class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |t|
      t.integer :api_id, null: false, unique: true
      t.string :title, null: false, unique: true
      t.float :user_score, null: false
      t.text :overview, null: false
      t.string :trailer_url, null: false, unique: true
      t.string :poster_url, null: false
      t.date :release_date, null: false

      t.timestamps
    end
  end
end
