json.array! @events do |event|
  json.id event.id
  json.title event.subject
  json.timezone 'UTC'
  json.start event.start.date_time
  json.end event.end.date_time
end