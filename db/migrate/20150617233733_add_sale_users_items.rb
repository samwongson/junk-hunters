class AddSaleUsersItems < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
    end
  

  
    create_table :sales do |t|
      t.string :address
      t.string :start_time
      t.string :end_time
      t.text :description
      t.string :image_path
      t.belongs_to :user, index: true
    end

    create_table :items do |t|
      t.belongs_to :sale, index: true
      t.string :name
    end
  end
end
