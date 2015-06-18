class AddZipcode < ActiveRecord::Migration
  def change
    change_table :sales do |t|
      t.float :longitude
      t.float :latitude
    end
  end
end
