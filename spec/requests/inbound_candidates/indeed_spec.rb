

describe "create Payment on Successful charge" do 
  let(:company) {Fabricate(:company)}
  let(:job_board) {Fabricate(:job_board, subdomain: "talentwiz", company: company)}
  let(:alice) {Fabricate(:user, company: company, role: "Admin")}
  let(:job) {Fabricate(:job, company: company, user_ids: alice.id)}
  let(:multichoice) {Fabricate(:question, kind: "Multiselect")}
  let(:singlechoice) {Fabricate(:question, kind: "Select (One)")}
  let(:question) {Fabricate(:question, job_id: job.id, kind: "Text (Long Answer)")}
  
  let(:option1) {Fabricate(:question_option, question_id: multichoice.id)}
  let(:option2) {Fabricate(:question_option, question_id: multichoice.id)}
  let(:option3) {Fabricate(:question_option, question_id: singlechoice.id)}
  let(:option4) {Fabricate(:question_option, question_id: singlechoice.id)}

  let(:event_data) do
    {  
      "locale":"en_US",
      "appliedOnMillis":1324051581711,
      "job":{  
        "jobId":"7775e2bc62b7f77e",
        "jobTitle":"Test Engineer",
        "jobCompany":"Your Company",
        "jobLocation":"New York, NY 10110",
        "jobUrl":"http://www.yourcompany.com/careers/yourjob123.html",
        "jobMeta":""
      },
      "applicant":{  
        "fullName":"John Doe",
        "email":"john.doe@indeed.com",
        "phoneNumber":"555-555-4321",
        "coverletter":"coverletter - text",
        "resume":{  
          "text":"resume - text",
          "hrXml":"resume-hr-xml",
          "html":"resume - html",
          "json":{  
            "firstName":"John",
            "lastName":"Doe",
            "headline":"headline",
            "summary":"summary",
            "publicProfileUrl":"http://www.indeed.com/r/123456",
            "additionalInfo":"me-additionalinfo",
            "phoneNumber":"555-555-4321",
            "location":{  
              "city":"Austin, TX"
            },
            "skills":"HTML, JavaScript",
            "positions":{  
              "_total":1,
              "values":[  
                {  
                  "title":"Product Manager",
                  "company":"Indeed",
                  "location":"Austin, TX",
                  "startDateMonth":"09",
                  "startDateYear":"2007",
                  "endDateMonth":"-1",
                  "endDateYear":"-1",
                  "endCurrent":true,
                  "description":"I am the current product manager for Indeed Apply."
                }
              ]
            },
            "educations":{  
              "_total":1,
              "values":[  
                {  
                  "degree":"B.A.",
                  "field":"Computer Science",
                  "school":"University of Texas, Austin",
                  "location":"Austin, TX",
                  "startDate":"2002",
                  "endDate":"2006",
                  "endCurrent":false
                }
              ]
            },
            "links":{  
              "_total":1,
              "values":[  
                {  
                  "url":"http://www.indeed.com"
                }
              ]
            },
            "awards":{  
              "_total":1,
              "values":[  
                {  
                  "title":"Best PM at Indeed",
                  "dateMonth":"04",
                  "dateYear":"2008",
                  "description":"Best PM is voted on by Indeed employees and given to the PM with the most votes."
                }
              ]
            },
            "certifications":{  
              "_total":1,
              "values":[  
                {  
                  "title":"cert-title",
                  "startDateMonth":"02",
                  "startDateYear":"2007",
                  "endDateMonth":"02",
                  "endDateYear":"2008",
                  "endCurrent":false,
                  "description":"cert-description"
                }
              ]
            },
            "associations":{  
               "_total":1,
               "values":[  
                {  
                  "title":"group-title",
                  "startDateMonth":"01",
                  "startDateYear":"2009",
                  "endDateMonth":"-1",
                  "endDateYear":"-1",
                  "endCurrent":true,
                  "description":"group-description"
                }
              ]
            },
            "patents":{  
               "_total":1,
               "values":[  
                {  
                  "patentNumber":"patent-number",
                  "title":"patent-title",
                  "url":"patent-url",
                  "dateMonth":"02",
                  "dateYear":"2009",
                  "description":"patent-description"
                }
              ]
            },
            "publications":{  
               "_total":1,
               "values":[  
                {  
                  "title":"pub-title",
                  "url":"pub-url",
                  "dateDay":"14",
                  "dateMonth":"10",
                  "dateYear":"2004",
                  "description":"pub-description"
                }
              ]
            },
            "militaryServices":{  
              "_total":1,
              "values":[  
                {  
                  "serviceCountry":"mil-country",
                  "branch":"mil-branch",
                  "rank":"mil-rank",
                  "startDateMonth":"02",
                  "startDateYear":"2003",
                  "endDateMonth":"12",
                  "endDateYear":"2008",
                  "endCurrent":false,
                  "commendations":"mil-commendations",
                  "description":"mil-description"
                }
              ]
            }
          },
          "file":{  
            "contentType":"application/octet-stream",
            "data":"SGVsbG8h=",
            "fileName":"John_Doe.pdf"
          }
        }
      }
    }
  end

end