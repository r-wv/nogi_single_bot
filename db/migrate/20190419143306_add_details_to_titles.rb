class AddDetailsToTitles < ActiveRecord::Migration[5.2]
  def change
    add_column :titles, :id, :string
  end
end
