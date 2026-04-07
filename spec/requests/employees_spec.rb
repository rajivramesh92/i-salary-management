require "rails_helper"

RSpec.describe "Api::V1::Employees", type: :request do
  let!(:employee1) do
     FactoryBot.create(
      :employee,
      full_name: "Vikas Sharma",
      job_title: "Software Engineer",
      country: "India",
      salary: 90000,
      department: "Engineering",
      email: "vikas@example.com",
      employment_type: "Full-time",
      date_of_joining: "2023-01-10"
    )
  end

  let!(:employee2) do
     FactoryBot.create(
      :employee,
      full_name: "John Smith",
      job_title: "Product Manager",
      country: "USA",
      salary: 120000,
      department: "Product",
      email: "john@example.com",
      employment_type: "Full-time",
      date_of_joining: "2022-06-15"
    )
  end

  let!(:employee3) do
     FactoryBot.create(
      :employee,
      full_name: "Priya Patel",
      job_title: "Software Engineer",
      country: "India",
      salary: 95000,
      department: "Engineering",
      email: "priya@example.com",
      employment_type: "Contract",
      date_of_joining: "2024-02-20"
    )
  end

  describe "GET /api/v1/employees" do
    it "returns all employees" do
      get "/api/v1/employees"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["employees"].length).to eq(3)
    end

    it "filters employees by search" do
      get "/api/v1/employees", params: { search: "vikas" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["employees"].length).to eq(1)
      expect(json["employees"].first["full_name"]).to eq("Vikas Sharma")
    end

    it "filters employees by country" do
      get "/api/v1/employees", params: { country: "India" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["employees"].length).to eq(2)
      expect(json["employees"].map { |e| e["country"] }.uniq).to eq(["India"])
    end

    it "filters employees by job title" do
      get "/api/v1/employees", params: { job_title: "Software Engineer" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["employees"].length).to eq(2)
      expect(json["employees"].map { |e| e["job_title"] }.uniq).to eq(["Software Engineer"])
    end

    it "sorts employees by salary ascending" do
      get "/api/v1/employees", params: { sort: "salary", direction: "asc" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      salaries = json["employees"].map { |e| e["salary"].to_i }

      expect(salaries).to eq(salaries.sort)
    end

    it "sorts employees by salary descending" do
      get "/api/v1/employees", params: { sort: "salary", direction: "desc" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      salaries = json["employees"].map { |e| e["salary"].to_i }

      expect(salaries).to eq(salaries.sort.reverse)
    end

    it "returns validation errors for invalid update" do
      patch "/api/v1/employees/#{employee1.id}", params: {
        employee: { email: employee2.email }
      }

      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)
      expect(json["errors"]).to be_present
    end

    it "returns not found for invalid id" do
      get "/api/v1/employees/999999"

      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body)
      expect(json["error"]).to be_present
    end
  end

  describe "POST /api/v1/employees" do
    let(:valid_params) do
      {
        employee: {
          full_name: "Aman Verma",
          job_title: "QA Engineer",
          country: "India",
          salary: 70000,
          department: "Engineering",
          email: "aman@example.com",
          employment_type: "Full-time",
          date_of_joining: "2024-01-01"
        }
      }
    end

    let(:invalid_params) do
      {
        employee: {
          full_name: "",
          job_title: "",
          country: "",
          salary: nil,
          department: "",
          email: "",
          employment_type: "",
          date_of_joining: nil
        }
      }
    end

    it "creates a new employee" do
      expect {
        post "/api/v1/employees", params: valid_params
      }.to change(Employee, :count).by(1)

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)
      expect(json["employee"]["full_name"]).to eq("Aman Verma")
    end

    it "returns validation errors for invalid params" do
      post "/api/v1/employees", params: invalid_params

      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)
      expect(json["errors"]).to be_present
    end
  end

  describe "PATCH /api/v1/employees/:id" do
    let(:update_params) do
      {
        employee: {
          full_name: "Vikas Updated",
          salary: 110000
        }
      }
    end

    it "updates the employee" do
      patch "/api/v1/employees/#{employee1.id}", params: update_params

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["employee"]["full_name"]).to eq("Vikas Updated")
      expect(json["employee"]["salary"].to_i).to eq(110000)

      employee1.reload
      expect(employee1.full_name).to eq("Vikas Updated")
      expect(employee1.salary.to_i).to eq(110000)
    end

    it "returns validation errors for invalid update" do
      patch "/api/v1/employees/#{employee1.id}", params: {
        employee: { email: employee2.email }
      }

      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)
      expect(json["errors"]).to be_present
    end
  end

  describe "DELETE /api/v1/employees/:id" do
    it "deletes the employee" do
      expect {
        delete "/api/v1/employees/#{employee1.id}"
      }.to change(Employee, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
