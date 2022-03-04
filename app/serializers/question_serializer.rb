class QuestionSerializer < ApplicationSerializer
  attributes :id, :title, :private, :created_at, :updated_at
  belongs_to :user
  has_many :answers
end
