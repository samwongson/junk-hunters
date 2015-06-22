require 'rake'
require "sinatra/activerecord/rake"
require ::File.expand_path('../config/environment', __FILE__)

Rake::Task["db:create"].clear
Rake::Task["db:drop"].clear

# NOTE: Assumes SQLite3 DB
desc "create the database"
task "db:create" do
  touch 'db/db.sqlite3'
end

desc "reset database"
task "db:rebirth" do
  exec("rake db:drop; rake db:create; rake db:migrate; rake db:populate")
end

desc "Populate"
task "db:populate" do
  @user = User.create(
    username: "pepito", 
    password_salt: "$2a$10$DLb1DfIzmkcEsHSn6uIWNe", 
    password: "$2a$10$DLb1DfIzmkcEsHSn6uIWNeG.fci3SeF7uep72eNRzLsmi4XJUPU1q"
  )

  @sale_1 =  Sale.create(
    address: "659 E Hastings St, Vancouver", 
    start_time: Time.now, 
    end_time: Time.now + (60*60), 
    description: "Hipster heaven", 
    image_path: open('garage_sale.jpg'), 
    user_id: @user.id
    )

  Item.create!(sale_id: @sale_1.id, item_name: "Old fashioned diving gear")
  Item.create!(sale_id: @sale_1.id, item_name: "Inflatable kangaroo")
  Item.create!(sale_id: @sale_1.id, item_name: "Cop hat")
  Item.create!(sale_id: @sale_1.id, item_name: "Miscellaneous sports gear")

  @sale_2 = Sale.create(
    address: "979 w 18th Vancouver", 
    start_time: Time.now, 
    end_time: Time.now + (60*60), 
    description: "Grandma is selling her stuff", 
    image_path: open('public/images/default_sale/sale_2.jpg'), 
    user_id: @user.id
    )
  Item.create!(sale_id: @sale_2.id, item_name: "Fancy collectors plates")
  Item.create!(sale_id: @sale_2.id, item_name: "Vintage nighty")
  Item.create!(sale_id: @sale_2.id, item_name: "Vases")
  Item.create!(sale_id: @sale_2.id, item_name: "Ash trays")
  Item.create!(sale_id: @sale_2.id, item_name: "14\" CRT TV")

  @sale_3 = Sale.create(
    address: "1601-1607 E Hastings St, Vancouver", 
    start_time: Time.now, 
    end_time: Time.now + (60*60), 
    description: "Pop up thrift shop", 
    image_path: open('public/images/default_sale/sale_3.jpg'), 
    user_id: @user.id
    )

  Item.create!(sale_id: @sale_3.id, item_name: "Colorful clothes")
  Item.create!(sale_id: @sale_3.id, item_name: "Handbags")
  Item.create!(sale_id: @sale_3.id, item_name: "Vintage art")

  @sale_4 = Sale.create(
    address: "3200 E Hastings St, Vancouver", 
    start_time: Time.now, 
    end_time: Time.now + (60*50), 
    description: "Fine furniture", 
    image_path: open('public/images/default_sale/sale_4.jpg'), 
    user_id: @user.id
    )

  Item.create!(sale_id: @sale_4.id, item_name: "Rocking chair")
  Item.create!(sale_id: @sale_4.id, item_name: "Lamps")
  Item.create!(sale_id: @sale_4.id, item_name: "Dressers")

  @sale_5 = Sale.create(
    address: "7004 Inlet Dr, Burnaby", 
    start_time: Time.now, 
    end_time: Time.now + (60*120), 
    description: "Jewelery and stuff", 
    image_path: open('public/images/default_sale/sale_5.jpg'), 
    user_id: @user.id
    )

  Item.create!(sale_id: @sale_5.id, item_name: "Feather hair extensions")
  Item.create!(sale_id: @sale_5.id, item_name: "Earrings")
  Item.create!(sale_id: @sale_5.id, item_name: "Bracelets")
  Item.create!(sale_id: @sale_5.id, item_name: "Skull stuff")

  @sale_6 = Sale.create!(
    address: "610 Gore Ave, Vancouver", 
    start_time: Time.now, 
    end_time: Time.now + (60*300), 
    description: "Pepper sale", 
    image_path: open('public/images/default_sale/sale_6.jpg'), 
    user_id: @user.id
    )

  Item.create!(sale_id: @sale_6.id, item_name: "Serrano")
  Item.create!(sale_id: @sale_6.id, item_name: "Jalepeno")
  Item.create!(sale_id: @sale_6.id, item_name: "Tiny orange")
end

desc "drop the database"
task "db:drop" do
  rm_f 'db/db.sqlite3'
end

task 'db:create_migration' do
  unless ENV["NAME"]
    puts "No NAME specified. Example usage: `rake db:create_migration NAME=create_users`"
    exit
  end

  name    = ENV["NAME"]
  version = ENV["VERSION"] || Time.now.utc.strftime("%Y%m%d%H%M%S")

  ActiveRecord::Migrator.migrations_paths.each do |directory|
    next unless File.exist?(directory)
    migration_files = Pathname(directory).children
    if duplicate = migration_files.find { |path| path.basename.to_s.include?(name) }
      puts "Another migration is already named \"#{name}\": #{duplicate}."
      exit
    end
  end

  filename = "#{version}_#{name}.rb"
  dirname  = ActiveRecord::Migrator.migrations_path
  path     = File.join(dirname, filename)

  FileUtils.mkdir_p(dirname)
  File.write path, <<-MIGRATION.strip_heredoc
    class #{name.camelize} < ActiveRecord::Migration
      def change
      end
    end
  MIGRATION

  puts path
end

desc 'Retrieves the current schema version number'
task "db:version" do
  puts "Current version: #{ActiveRecord::Migrator.current_version}"
end
