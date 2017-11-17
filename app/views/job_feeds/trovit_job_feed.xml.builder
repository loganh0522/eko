xml.instruct!(:xml, :version=> "1.0", :encoding => "UTF-8")

xml.trovit do
  @jobs.each do |job|
    xml.ad do
      xml.id { xml.cdata!((job.id).to_s) }
      xml.title { xml.cdata!(job.title) }
      xml.url { xml.cdata!(job.url) }
      xml.content { xml.cdata!(job.description) }
      xml.company { xml.cdata! (job.company.name)}
      xml.city { xml.cdata! (job.city) }
      xml.region { xml.cdata! (job.province) }
      xml.category { xml.cdata! (job.industry) if job.industry.present? }
      xml.contract { xml.cdata! (job.kind) if job.kind.present?}
      xml.salary { xml.cdata! (job.start_salary) if job.start_salary.present?}
      xml.date {xml.cdata!((job.created_at).to_s)}
    end
  end
end


