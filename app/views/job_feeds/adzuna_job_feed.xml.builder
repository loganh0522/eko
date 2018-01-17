xml.instruct!(:xml, :version=> "1.0", :encoding => "UTF-8")

xml.source do 
xml.publisher "TalentWiz"
xml.publisherurl "https://www.talentwiz.ca"
  xml.jobs do
    @jobs.each do |job|
      xml.job do
        xml.id { xml.cdata!((job.id).to_s) }
        xml.referencenumber { xml.cdata!((job.id).to_s) }
        
        xml.company { xml.cdata! (job.company.name)}
        xml.url { xml.cdata!(job.url) } if job.url.present?
        xml.title { xml.cdata!(job.title) }
        xml.description { xml.cdata!(job.description) }

        xml.location { xml.cdata!(job.location) } if job.location.present?
        xml.country { xml.cdata! (job.country) } if job.country.present?
        xml.city { xml.cdata! (job.city) } if job.province.present?
        xml.state { xml.cdata! (job.province) } if job.province.present?
        xml.category { xml.cdata!(job.industry)} if job.industry.present?

        xml.date {xml.cdata!((job.created_at).to_s)} if if job.created_at.present?
        xml.post_date {xml.cdata!((job.created_at).to_s)} if job.created_at.present?
        xml.expiration_date {xml.cdata!((job.created_at).to_s)} if job.created_at.present?
      end
    end
  end
end
