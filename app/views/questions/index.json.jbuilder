json.array @questions do |question|
  json.id question.id
  
  if question.kind == 'Multiselect'
    json.type "multiselect"
  elsif question.kind == 'Select (One)'
    json.type "select"
  elsif question.kind == 'File'
    json.type "file"
  elsif 'Text (Short Answer)'
    json.type "text"
  else
    json.type "textarea"
  end

  json.question question.body
  json.required question.required

  if question.question_options.present?
    json.array question.question_options do |option|
      json.value option.id
      json.label option.body
    end
  end
end

