require 'spec_helper'

describe InboundCandidatesController do 
  describe 'POST create' do
    let(:image_data) { Base64.encode64(File.open(File.join(Rails.root, '/spec/support/files/avatar.gif'), &:read)) }
    let(:image) { "data:image/gif;base64,#{ image_data }" }

    {"email":"talentwiz@ziptest2.com", "resume": "base64 here", 
      "first_name":"talentwiz","job_id":"14",
      "response_id":"55e9c2f1",
      "name": "talentwiz ziptest",
      "last_name":"ziptest",
      "phone":"+1 3101231234",
      "answers": [{"value":"15","id":"19"}, {"id":"21","value": "more base64","filename": "Michael Jones - short.pdf"},
        {"values":["22"],"id":"20"}, {"value":"yes","id":"18"}]}
    context 'with valid params' do
      let(:params) { { photo: { image: image } } }

      before do
        post :create,
             params: params,
             'Content-Type' => 'application/json',
              format: :json
      end

      it 'returns photo object' do
        expect(parsed_response_body(response.body)[:image][:url]).not_to be_empty
      end

      # be careful with the store_dir path!!!
      # unless you have store_dir paths separated based on environment
      # you may end up deleting production files too.
      after do
        FileUtils.rm_rf(File.join(Rails.root, user.photo.store_dir))
      end
    end
  end
end