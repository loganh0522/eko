xml.instruct!(:xml, :version=> "1.0", :encoding => "UTF-8")
xml.source do 
xml.publisher "TalentWiz"
xml.publisherurl "https://www.talentwiz.ca"
  xml.listing do
    @jobs.each do |job|
      xml.entry do
        xml.id { xml.cdata!((job.id).to_s) }
        xml.title { xml.cdata!(job.title) }
        
        xml.location do 
          xml.country { xml.cdata! (job.country) }
          xml.city { xml.cdata! (job.city) }
          xml.state { xml.cdata! (job.province) }
        end

        xml.description { xml.cdata!(job.description) }
        xml.date {xml.cdata!((job.created_at).to_s)}

        xml.company { xml.cdata! (job.company.name)}
        xml.url { xml.cdata!(job.url) }
        xml.category { xml.cdata! (job.industry)} if job.industry.present?
        xml.jobtype { xml.cdata! (job.kind)} if job.kind.present?
        xml.education {xml.cdata! (job.education_level)} if job.education_level.present?
      end
    end
  end
end