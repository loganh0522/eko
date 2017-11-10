xml.instruct!(:xml, :version=> "1.0", :encoding => "UTF-8")
xml.source do 
xml.publisher "TalentWiz"
xml.publisherurl "https://www.talentwiz.ca"
  xml.jobs do
    @jobs.each do |job|
      if job.status == 'open'
        xml.ad do
          xml.id { xml.cdata!((job.id).to_s) }
          xml.company { xml.cdata! (job.company.name)}
          xml.url { xml.cdata!(job.url) }
          xml.title { xml.cdata!(job.title) }
          xml.content { xml.cdata!(job.description) }
          xml.city { xml.cdata! (job.city) }
          xml.region { xml.cdata! (job.province) }
          xml.category { xml.cdata! (industries.first.name)}
          xml.contract { xml.cdata! (job.kind)}
          xml.date {xml.cdata!((job.created_at).to_s)}
        end
      end
    end
  end
end


