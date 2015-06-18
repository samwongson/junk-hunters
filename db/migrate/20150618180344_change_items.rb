class ChangeItems < ActiveRecord::Migration
  def change
    remove_column :items, :name

    add_column :items, :item_name, :string


  end
end
