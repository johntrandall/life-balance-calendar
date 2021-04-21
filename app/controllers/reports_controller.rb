class ReportsController < ApplicationController

  def index
    # file_name = "gruff/#{controller_name}_#{action_name}_#{current_user.id}.png"
    #
    @events = current_user.events.where(start_date: 1.week.ago...).or(
      current_user.events.where(start_date_time: 1.week.ago...)
    )
    filename = "#{current_user.id}-#{SecureRandom.uuid}"
    @file_name = write_graph_image(filename)
  end

  def generate_graph_filename
    # file_name = "gruff/#{controller_name}_#{action_name}_#{current_user.id}.png"
    # cache_key = "#{file_name}-#{@happening_template.happenings.minimum(:updated_at).to_i}"
    file_name = 'test
'
    write_graph_image(file_name)

    file_name
  end

  def write_graph_image(file_name)
    require 'gruff'
    g = Gruff::Pie.new
    g.title = 'LifeBalance'

    # categories = @events.pluck(:category).uniq
    categories = @events.map(&:category).uniq

    categories.each do |category|
      # duration = @events.where(category: category).sum(&:duration)
      duration = @events.select { |e| e.category == category }.sum(&:duration_in_minutes)
      g.data(category, [duration])
    end

    file_path = "app/assets/images/#{file_name}.png"
    g.write(file_path)

    file_name
  end

end
