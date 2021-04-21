class AddStartAndEndTime < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :start_date, :date
    add_column :events, :start_date_time, :datetime
    add_column :events, :end_date, :date
    add_column :events, :end_date_time, :datetime
    add_column :events, :remote_id, :string
  end
end
