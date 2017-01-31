xml.instruct! :xml, :version=>"1.0", :encoding => "UTF-8"
xml.jobs do
  @jobs.each do |job|
    xml.job do
      xml.title { xml.cdata!(job.title) }
      xml.description { xml.cdata!(job.description) }
      xml.location { xml.cdata!(job.location) }
      xml.contract_time { xml.cdata!(job.type) }
      xml.date
    end
  end
end