class AddDetailsToTitles < ActiveRecord::Migration[5.2]
  def change
    add_column :titles, :number, :string
  end
end
