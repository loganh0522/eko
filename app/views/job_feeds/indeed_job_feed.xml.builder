xml.instruct!(:xml, :version=> "1.0", :encoding => "UTF-8")
xml.source do 
xml.publisher "TalentWiz"
xml.lastBuildDate ""
xml.publisherurl "https://www.talentwiz.ca"
  xml.listing do
    @jobs.each do |job|
      xml.entry do
        xml.title { xml.cdata!(job.title) }
        xml.description { xml.cdata!(job.description) } 
        xml.date {xml.cdata!((job.created_at).to_s)}
        xml.referencenumber { xml.cdata!((job.id).to_s) }
        xml.url { xml.cdata!(job.url) }
        xml.company { xml.cdata! (job.company.name)}
        xml.sourcename "TalentWiz"
        xml.city { xml.cdata! (job.city) } if job.city.present?
        xml.state { xml.cdata! (job.province) } if job.province.present?
        xml.country { xml.cdata! (job.country) } if job.country.present?  
        xml.salary { xml.cdata!(job.salary) } if job.start_salary.present?
        xml.category {xml.cdata! (job.industry)} if job.industry.present?
        xml.jobtype {xml.cdata! (job.kind)} if job.kind.present?
        xml.education {xml.cdata! (job.education_level)} if job.education_level.present?
      end
    end
  end
end
