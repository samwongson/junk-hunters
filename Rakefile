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
  @user = User.create!(username: "john", password: "john")
  @sale = Sale.create!(address: "610 Gore Ave, Vancouver", start_time: "2015-04-20", end_time: "2015-04-20", description: "Yard Sale", image_path: open('garage.jpg'), user_id: @user.id)
  @item1 = Item.create!(sale_id: @sale.id, item_name: "carrots")
  @item2 = Item.create!(sale_id: @sale.id, item_name: "pigs")
  @item3 = Item.create!(sale_id: @sale.id, item_name: "tools")

  @user2 = User.create!(username: "pepe", password: "pepe")
  @sale2 = Sale.create(address: "978 w 18th Vancouver", start_time: Time.now, end_time: Time.now + (60*60), description: "asdffds", image_path: open('brickwall.png'), user_id: @user2.id)
  @item4 = Item.create!(sale_id: @sale2.id, item_name: "more carrots")
  @item5 = Item.create!(sale_id: @sale2.id, item_name: "lots of pigs")
  @item6 = Item.create!(sale_id: @sale2.id, item_name: "tools")

  Sale.create(address: "659 E Hastings St, Vancouver", start_time: Time.now, end_time: Time.now + (60*60), description: "This sale is pretty close", image_path: open('garage_sale.jpg'), user_id: @user2.id)

  Sale.create(address: "1601-1607 E Hastings St, Vancouver", start_time: Time.now, end_time: Time.now + (60*60), description: "This sale is a little further", image_path: open('garage_sale.jpg'), user_id: @user2.id)

  Sale.create(address: "3200 E Hastings St, Vancouver", start_time: Time.now, end_time: Time.now + (60*50), description: "This sale is even further", image_path: open('garage_sale.jpg'), user_id: @user2.id)

  Sale.create(address: "7004 Inlet Dr, Burnaby", start_time: Time.now, end_time: Time.now + (60*120), description: "This sale is pretty far", image_path: open('garage_sale.jpg'), user_id: @user2.id)

  Sale.create(address: "1120 Johnson St, Coquitlam", start_time: Time.now, end_time: Time.now + (60*360), description: "This sale REALLY far", image_path: open('garage_sale.jpg'), user_id: @user2.id)

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
