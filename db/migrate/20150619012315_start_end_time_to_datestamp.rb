class StartEndTimeToDatestamp < ActiveRecord::Migration
  def change
    change_column :sales, :start_time, 'datetime with time zone'
    change_column :sales, :end_time, 'datetime with time zone'
  end
end
