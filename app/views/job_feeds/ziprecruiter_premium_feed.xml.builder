xml.instruct!(:xml, :version=> "1.0", :encoding => "UTF-8")
xml.source do 
xml.publisher "TalentWiz"
xml.publisherurl "https://www.talentwiz.ca"
  xml.jobs do
    @jobs.each do |job|
      xml.job do
        xml.referencenumber { xml.cdata!((job.id).to_s) }
        xml.url { xml.cdata!(job.url) }
        xml.title { xml.cdata!(job.title) }
        xml.description { xml.cdata!(job.description) }
        xml.country { xml.cdata! (job.country) }
        xml.city { xml.cdata! (job.city) }
        xml.state { xml.cdata! (job.province) }
        xml.company { xml.cdata! (job.company.name)}
        if job.ziprecruiter_premium_feed.boost == true
          xml.trafficboost {xml.cdata! ('double')} 
        else
          xml.trafficboost {xml.cdata! ('single')} 
        end
        xml.category { xml.cdata!(job.industry) } if job.industry.present?
        xml.date {xml.cdata!((job.created_at).to_s)} 
        xml.job_type { xml.cdata!(job.kind) } if job.kind.present?
        xml.compensation_min { xml.cdata!(job.start_salary) } if job.start_salary.present?
        xml.compensation_max { xml.cdata!(job.end_salary) } if job.end_salary.present?

        if job.questions.present?
          xml.interview_json do
            @questions = []
            job.questions.each do |question|
              @options = []   
              
              if question.question_options.present?
                question.question_options.each do |option|
                  @options << {value: option.id.to_s, label: option.body}
                end
              end

              if question.kind == 'Multiselect'
                jsonInterview = {}
                jsonInterview['id'] = question.id.to_s
                jsonInterview['type'] = "multiselect"
                jsonInterview['questions'] = question.body
                jsonInterview['options'] = @options
                jsonInterview['required'] = question.required
              elsif question.kind == 'Select (One)'
                jsonInterview = {}
                jsonInterview['id'] = question.id.to_s
                jsonInterview['type'] = "select"
                jsonInterview['question'] = question.body
                jsonInterview['options'] = @options
                jsonInterview['required'] = question.required
              elsif question.kind == 'File'
                jsonInterview = {}
                jsonInterview['id'] = question.id.to_s
                jsonInterview['type'] = "upload"
                jsonInterview['question'] = question.body
                jsonInterview['required'] = question.required
              else
                jsonInterview = {}
                jsonInterview['id'] = question.id.to_s
                jsonInterview['type'] = 'text'
                jsonInterview['question'] = question.body
                jsonInterview['required'] = question.required
              end
              @questions.push(jsonInterview)
            end
            xml.cdata!(@questions.to_json)
          end
        end
      end
    end
  end
end