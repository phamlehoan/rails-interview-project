module Api
  module V1
    class QuestionsController < ApplicationController
      before_action :api_key_valid?

      def index
        questions = Question.where(private: false).includes(:user, :answers)
        render json: questions, each_serializer: QuestionSerializer
      end
    end
  end
end