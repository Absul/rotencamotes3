class AddPlayReferenceToPosts < ActiveRecord::Migration
  def change
    mysqladd_column :posts, :play_id, :integer
  end
end
