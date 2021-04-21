# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  category        :string
#  end_date        :date
#  end_date_time   :datetime
#  google_data     :jsonb
#  start_date      :date
#  start_date_time :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remote_id       :string
#  user_id         :bigint
#
# Indexes
#
#  index_events_on_user_id  (user_id)
#
class Event < ApplicationRecord
  scope :categorized, -> { where.not(category: nil) }

  def summary
    JSON.parse(google_data)["summary"]
  end

  def categorized?
    category.present?
  end

  def duration_in_minutes
    if start_date_time.present?
      (end_date_time - start_date_time)/60
    else
      (Date.iso8601(end_date.to_s) - Date.iso8601(start_date.to_s)).to_i * 8 * 60
    end
  end
end
