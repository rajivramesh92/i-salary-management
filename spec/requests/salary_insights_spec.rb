require "rails_helper"

RSpec.describe "Api::V1::SalaryInsights", type: :request do
  describe "GET /api/v1/salary_insights" do
    it "returns salary overview insights" do
      allow(SalaryInsightsService).to receive(:overview).and_return({
        total_employees: 10000,
        total_countries: 5,
        overall_average_salary: 75000.0
      })

      get "/api/v1/salary_insights"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["total_employees"]).to eq(10000)
      expect(json["total_countries"]).to eq(5)
      expect(json["overall_average_salary"]).to eq(75000.0)
    end
  end

  describe "GET /api/v1/salary_insights/by_country" do
    context "when country is present" do
      it "returns country specific salary insights" do
        allow(SalaryInsightsService).to receive(:by_country).with("India").and_return({
          country: "India",
          total_employees: 2500,
          minimum_salary: 30000,
          maximum_salary: 150000,
          average_salary: 85000.5
        })

        get "/api/v1/salary_insights/by_country", params: { country: "India" }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["country"]).to eq("India")
        expect(json["total_employees"]).to eq(2500)
        expect(json["minimum_salary"]).to eq(30000)
        expect(json["maximum_salary"]).to eq(150000)
        expect(json["average_salary"]).to eq(85000.5)
      end
    end

    context "when country is missing" do
      it "returns unprocessable entity" do
        get "/api/v1/salary_insights/by_country"

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json["error"]).to eq("country is required")
      end
    end
  end

  describe "GET /api/v1/salary_insights/by_country_and_job_title" do
    context "when country and job_title are present" do
      it "returns salary insights for given country and job title" do
        allow(SalaryInsightsService).to receive(:by_country_and_job_title)
          .with("India", "Software Engineer")
          .and_return({
            country: "India",
            job_title: "Software Engineer",
            total_employees: 500,
            minimum_salary: 50000,
            maximum_salary: 180000,
            average_salary: 95000.75
          })

        get "/api/v1/salary_insights/by_country_and_job_title", params: {
          country: "India",
          job_title: "Software Engineer"
        }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["country"]).to eq("India")
        expect(json["job_title"]).to eq("Software Engineer")
        expect(json["total_employees"]).to eq(500)
        expect(json["minimum_salary"]).to eq(50000)
        expect(json["maximum_salary"]).to eq(180000)
        expect(json["average_salary"]).to eq(95000.75)
      end
    end

    context "when country is missing" do
      it "returns unprocessable entity" do
        get "/api/v1/salary_insights/by_country_and_job_title", params: {
          job_title: "Software Engineer"
        }

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json["error"]).to eq("country and job_title are required")
      end
    end

    context "when job_title is missing" do
      it "returns unprocessable entity" do
        get "/api/v1/salary_insights/by_country_and_job_title", params: {
          country: "India"
        }

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json["error"]).to eq("country and job_title are required")
      end
    end

    context "when both country and job_title are missing" do
      it "returns unprocessable entity" do
        get "/api/v1/salary_insights/by_country_and_job_title"

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json["error"]).to eq("country and job_title are required")
      end
    end
  end
end