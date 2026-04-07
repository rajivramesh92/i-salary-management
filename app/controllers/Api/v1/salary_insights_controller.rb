module Api
  module V1
    class SalaryInsightsController < ApplicationController
      def index
        render json: SalaryInsightsService.overview
      end

      def by_country
        country = params[:country]

        if country.blank?
          return render json: { error: "country is required" }, status: :unprocessable_entity
        end

        render json: SalaryInsightsService.by_country(country)
      end

      def by_country_and_job_title
        country = params[:country]
        job_title = params[:job_title]

        if country.blank? || job_title.blank?
          return render json: { error: "country and job_title are required" }, status: :unprocessable_entity
        end

        render json: SalaryInsightsService.by_country_and_job_title(country, job_title)
      end
    end
  end
end