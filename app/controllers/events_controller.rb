
class EventsController < ApplicationController

  def index

  end


  private

  def google_calendar_service(user)
    @google_calendar_service ||= begin
                                   secrets = Google::APIClient::ClientSecrets.new(
                                     { "web" =>
                                         { "access_token" => user.token,
                                           "refresh_token" => user.refresh_token,
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
end
