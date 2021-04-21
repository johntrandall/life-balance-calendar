require 'google/api_client/client_secrets.rb'
require "google/apis/calendar_v3"

class EventsController < ApplicationController
  def index
    google_events = get_event_list.items

    google_events.each do |g_event|
      current_user.events.where(remote_id: g_event.id).first_or_create!(
        google_data: g_event.to_json,
        start_date: g_event.start.date,
        start_date_time: g_event.start.date_time,
        end_date: g_event.end.date,
        end_date_time: g_event.end.date_time,
        remote_id: g_event.id
        )
    end
    @events = current_user.events
    categories = @events.map(&:category).uniq

    @category_groups = categories.map do |category|
      duration = @events.select { |e| e.category == category }.sum(&:duration_in_minutes)
      [category, duration]
    end
  end

  def update
    @event = Event.find(params[:id])
    @event.update!(event_params)

    redirect_to events_path
  end

  def event_params
    params.permit(:category)
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
