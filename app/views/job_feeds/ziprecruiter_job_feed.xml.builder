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
        xml.trafficboost {xml.cdata! (job.job_feed.ziprecruiter_boost)} if job.job_feed.ziprecruiter_boost.present?
        xml.category { xml.cdata!(job.industry) } if job.industry.present?
        xml.date {xml.cdata!((job.created_at).to_s)} 
        xml.job_type { xml.cdata!(job.kind) } if job.kind.present?
        xml.compensation_min { xml.cdata!(job.start_salary) } if job.start_salary.present?
        xml.compensation_max { xml.cdata!(job.end_salary) } if job.end_salary.present?


        xml.interview_json do
          job.questions.each do |question|
            @options = []   
            if question.question_options.present?
              question.question_options.each do |option|
                @options << {value: option.id.to_s, label: option.body}
              end
            end
            jsonInterview = "[{
              :id => #{question.id.to_s},
              :type => #{question.kind},
              :question => #{question.body},
              :options => #{@options}
              }]"

            xml.cdata!(jsonInterview)
          end
          
        end
      end
    end
  end
end

# if question.question_options.present? 
#                 '"options": ['
#                 
#                 ']
#               }]'

