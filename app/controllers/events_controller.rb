require 'google/api_client/client_secrets.rb'
require "google/apis/calendar_v3"

class EventsController < ApplicationController
  def index
    @events = get_event_list.items
    # raise 'hell'
  end

  private

  def google_calendar_service
    @google_calendar_service ||= begin
                                   secrets = Google::APIClient::ClientSecrets.new(
                                     { "web" =>
                                         { "access_token" => current_user.token,
                                           "refresh_token" => current_user.refresh_token,
                                           "client_id" => Rails.application.credentials.google.fetch(:client_id),
                                           "client_secret" => Rails.application.credentials.google.fetch(:client_secret)
                                         }
                                     }
                                   )
                                   google_calendar_service = Google::Apis::CalendarV3::CalendarService.new
                                   google_calendar_service.authorization = secrets.to_authorization
                                   google_calendar_service
                                 end
  end

  def get_event_list
    google_calendar_service.authorization.refresh!
    calendar_id = "primary"
    google_calendar_service.list_events(calendar_id,
                                   max_results:   50,
                                   single_events: true,
                                   order_by:      "startTime",
                                   time_min:      1.week.ago.rfc3339)
  end
end
