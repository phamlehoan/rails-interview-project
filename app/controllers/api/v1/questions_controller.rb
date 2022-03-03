module Api
  module V1
    class QuestionsController < ApplicationController
      def index
        questions = Question.where(private: false).includes(:user, :answers)
        render json: questions, each_serializer: QuestionSerializer
      end
    end
  end
end