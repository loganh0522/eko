xml.instruct!(:xml, :version=> "1.0", :encoding => "UTF-8")
xml.source do 
xml.publisher "TalentWiz"
xml.lastBuildDate ""
xml.publisherurl "https://www.talentwiz.ca"
  xml.listing do
    @jobs.each do |job|
      xml.entry do
        xml.title { xml.cdata!(job.title) }
        xml.date {xml.cdata!((job.created_at).to_s)}
        xml.referencenumber { xml.cdata!((job.id).to_s) }
        xml.url { xml.cdata!(job.url) }
        xml.company { xml.cdata! (job.company.name)}
        xml.sourcename "TalentWiz"
        xml.city { xml.cdata! (job.city) }
        xml.state { xml.cdata! (job.province) }
        xml.country { xml.cdata! (job.country) }
        xml.postalcode {xml.cdata! (job.postalcode)}
        xml.email {xml.cdata! (job.company.users.first.email)}
        xml.description { xml.cdata!(job.description) }
        xml.salary { xml.cdata!(job.salary) }     
        xml.category {xml.cdata! (job.industry)}
        xml.jobtype {xml.cdata! (job.kind)}
        xml.education {xml.cdata! (job.education_level)}
        xml.sponsored {xml.cdata! (job.job_feed.indeed_sponsored)} 
        xml.budget {xml.cdata! (job.job_feed.indeed_budget)} 
      end
    end
  end
end

<source>
  <publisher/>     
  <publisherurl/> 
  <job>
    <title/>
    <date/> 
    <referencenumber/>
    <url/>
    <company/>
    <sourcename/>
    <city/>
    <state/>
    <country/>
    <email/>
    <postalcode/>
    <description/>
    <salary/>
    <education/>
    <jobtype/>
    <category/>
    <experience/>
    <indeed-apply-data>
    </indeed-apply-data>
  </job>
</source>