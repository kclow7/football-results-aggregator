class AddVideoTitleToMatches < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :video_title, :string
  end
end
