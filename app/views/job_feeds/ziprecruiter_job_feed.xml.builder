xml.instruct!(:xml, :version=> "1.0", :encoding => "UTF-8")
xml.source do 
xml.publisher "TalentWiz"
xml.publisherurl "https://www.talentwiz.ca"
  xml.jobs do
    @jobs.each do |job|
      if job.status == 'open'
        xml.job do
          xml.id { xml.cdata!((job.id).to_s) }
          xml.referencenumber { xml.cdata!((job.id).to_s) }
          xml.company { xml.cdata! (job.company.name)}
          xml.trafficboost {xml.cdata! (job.job_feed.ziprecruiter_boost)}
          
          xml.url { xml.cdata!(job.url) }
          xml.title { xml.cdata!(job.title) }
          xml.description { xml.cdata!(job.description) }
          
          xml.location { xml.cdata!(job.location) }
          xml.country { xml.cdata! (job.country) }
          xml.city { xml.cdata! (job.city) }
          xml.state { xml.cdata! (job.province) }
          
          xml.contract_time { xml.cdata!(job.industry) }
          
          xml.date {xml.cdata!((job.created_at).to_s)}
        end
      end
    end
  end
end



