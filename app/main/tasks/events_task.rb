require 'rest-client'
class EventTasks < Volt::Task

  def get_categories
    response = JSON.parse(
      RestClient.get "https://api.cityofnewyork.us/calendar/v1/categories.htm?app_id=#{ENV['EVENTS_PROJECT_ID']}&app_key=#{ENV['EVENTS_PROJECT_KEY']}"
    )
    response
  end

  def search_for_events(categories, boroughs)
    if boroughs.length > 0
      boroughs_cmd = '&boroughs=' + boroughs
    end

    response = JSON.parse(
      RestClient.get "https://api.cityofnewyork.us/calendar/v1/search.htm?app_id=#{ENV['EVENTS_PROJECT_ID']}&app_key=#{ENV['EVENTS_PROJECT_KEY']}#{boroughs_cmd}&categories=#{categories}"
    )
    result = []

    response["items"].each do |item| 
      result << {
        permalink: item["permalink"], 
        #manually parse the html
        desc: item["desc"].gsub('\\t','&nbsp;&nbsp;&nbsp;').gsub('\\n','<br>').gsub('\\','')
      }
    end
    
    result
  end

end