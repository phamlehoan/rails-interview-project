require 'rails_helper'

describe 'Questions API', type: :request do
  it 'sends a list of questions without API Key' do
    get '/api/v1/questions'

    expect(response).to have_http_status(:unauthorized) # 401
    expect(response.body).to eq({
      'status': 'ERROR',
      'message': 'No API key'
    }.to_json) # {"status": "ERROR", "message": "No API key"}
  end

  it 'sends a list of questions with wrong API Key' do
    get '/api/v1/questions', headers: { 'X-Api-Key': 'wrong_key' }

    expect(response).to have_http_status(:unauthorized) # 401
    expect(response.body).to eq({
      'status': 'ERROR',
      'message': 'Invalid API key'
    }.to_json) # {"status": "ERROR", "message": "Invalid API key"}
  end

  it 'success' do
    tenant = FactoryBot.create(:tenant)

    get '/api/v1/questions', headers: { 'X-Api-Key': tenant.api_key }
    tenant = Tenant.find_by(id: tenant.id)

    expect(response).to have_http_status(:success) # 200
    expect(tenant.number_of_requests).to eq(1) # +1 request for tracking

    json_response = JSON.parse(response.body)
    json_response.each do |question|
      check_question_fields(question) # {"id": 1, "title": "How to use API?", "private": false, "created_at": "2017-11-01T12:00:00.000Z", "updated_at": "2017-11-01T12:00:00.000Z", "user": {"id": 1, "name": "John Doe", "created_at": "2017-11-01T12:00:00.000Z", "updated_at": "2017-11-01T12:00:00.000Z"}, "answers": [{"id": 1, "body": "Answer 1", "question_id": 1, "user_id": 1, "created_at": "2017-11-01T12:00:00.000Z", "updated_at": "2017-11-01T12:00:00.000Z"}, {"id": 2, "body": "Answer 2", "question_id": 1, "user_id": 1, "created_at": "2017-11-01T12:00:00.000Z", "updated_at": "2017-11-01T12:00:00.000Z"}]}

      question["answers"].each do |answer|
        check_answer_fields(answer) # {"id": 1, "body": "Answer body", "question_id": 1, "user_id": 1, "created_at": "2017-11-01T00:00:00.000Z", "updated_at": "2017-11-01T00:00:00.000Z"}
      end

      check_user_fields(question["user"]) # {"id": 1, "name": "John Doe", "created_at": "2016-05-12T21:09:12.000Z", "updated_at": "2016-05-12T21:09:12.000Z"}
    end
  end
end

def check_question_fields(question)
  expect(question.keys).to match_array(["id", "title", "private", "created_at", "updated_at", "user", "answers"])
end

def check_answer_fields(answer)
  expect(answer.keys).to match_array(["id", "body", "question_id", "user_id", "created_at", "updated_at"])
end

def check_user_fields(user)
  expect(user.keys).to match_array(["id", "name", "created_at", "updated_at"])
end
