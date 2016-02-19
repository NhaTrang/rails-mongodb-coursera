json.place @result.overall_place
json.first_name @result.racer.first_name
json.last_name @result.racer.last_name
json.time format_hours(@result.secs)
json.bib @result.bib
json.city @result.racer.city
json.state @result.racer.state
#json.gender @result.gender.name
json.gender_place @result.gender_place
json.group @result.group.name
json.group_place @result.group.place
json.swim format_hours(@result.swim_secs)
json.pace_100 format_minutes(@result.swim_pace_100)
json.bike format_hours(@result.bike_secs)
json.mph format_mph(@result.bike_mph)
json.t1 format_minutes(@result.t1_secs)
json.t2 format_minutes(@result.t2_secs)
json.run format_hours(@result.run_secs)
json.mmile format_minutes(@result.run_mmile)
json.result_url api_race_result_url(@result.race.id, @result)
if @result.racer.id
  json.racer_url api_racer_url(@result.racer.id)
end