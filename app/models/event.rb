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
  def summary
    JSON.parse(google_data)["summary"]
  end
end
