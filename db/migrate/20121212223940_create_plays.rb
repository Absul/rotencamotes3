class CreatePlays < ActiveRecord::Migration
  def change
    create_table :plays do |t|
      t.string :title
      t.text :synopsis
      t.text :cast
      t.string :director
      t.string :author
      t.datetime :starting_at
      t.datetime :ending_at
      t.string :length
      t.string :cached_tag_list
      t.references :theatre

      t.timestamps
    end
    #add_column :schedules, :play_id, :integer
  end
end
