json.array! @events do |event|
  json.id event.id
  json.title event.subject
  json.editable false
  
  if DateTime.parse(event.start.date_time).strftime("%Y-%m-%dT%H:%M:%S%Z").in_time_zone("America/New_York").dst? 
    json.start DateTime.parse(event.start.date_time).strftime("%Y-%m-%dT%H:%M:%S%Z").in_time_zone("America/New_York") 
    json.end DateTime.parse(event.end.date_time).strftime("%Y-%m-%dT%H:%M:%S%Z").in_time_zone("America/New_York") 
  else
    json.start DateTime.parse(event.start.date_time).strftime("%Y-%m-%dT%H:%M:%S%Z").in_time_zone("America/New_York") 
    json.end DateTime.parse(event.end.date_time).strftime("%Y-%m-%dT%H:%M:%S%Z").in_time_zone("America/New_York") 
  end
end