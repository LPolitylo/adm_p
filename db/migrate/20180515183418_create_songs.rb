class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :lyrics
      t.integer :length
      t.date :released_on

      t.timestamps
    end
  end
end
