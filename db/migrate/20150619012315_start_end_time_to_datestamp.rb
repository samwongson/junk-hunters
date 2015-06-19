class StartEndTimeToDatestamp < ActiveRecord::Migration
  def change
    change_column :sales, :start_time, :datetime
    change_column :sales, :end_time, :datetime
  end
end
