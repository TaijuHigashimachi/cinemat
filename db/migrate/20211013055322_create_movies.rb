class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |t|
      t.integer :api_id, null: false
      t.string :title, null: false
      t.string :trailer_url, null: false
      t.datetime :release_date, null: false
      t.float :user_score, null: false
      t.text :overview, null: false

      t.timestamps
    end
  end
end
