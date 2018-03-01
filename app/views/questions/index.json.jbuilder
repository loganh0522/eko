json.array @questions do |question|
  json.id question.id
  if question.kind == 'text'
    json.type "textarea"
  else 
    json.type question.kind
  end


  json.question question.body
  json.condition question.required

  if question.question_options.present?
    json.array question.question_options do |option|
      json.value option.id
      json.label option.body
    end
  end
end

