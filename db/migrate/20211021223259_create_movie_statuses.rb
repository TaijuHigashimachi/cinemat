class CreateMovieStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :movie_statuses do |t|
      t.references :movie, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false

      t.timestamps
    end
  end
end
