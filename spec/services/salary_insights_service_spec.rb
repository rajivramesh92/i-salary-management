require "rails_helper"

RSpec.describe SalaryInsightsService, type: :service do
  before do
    Employee.delete_all

    FactoryBot.create(
      :employee,
      full_name: "Vikas Sharma",
      job_title: "Software Engineer",
      country: "India",
      salary: 90000,
      department: "Engineering",
      email: "vikas@example.com",
      employment_type: "Full-time",
      date_of_joining: Date.new(2023, 1, 1)
    )

    FactoryBot.create(
      :employee,
      full_name: "Priya Patel",
      job_title: "Software Engineer",
      country: "India",
      salary: 110000,
      department: "Engineering",
      email: "priya@example.com",
      employment_type: "Contract",
      date_of_joining: Date.new(2023, 2, 1)
    )

    FactoryBot.create(
      :employee,
      full_name: "Aman Verma",
      job_title: "Product Manager",
      country: "India",
      salary: 130000,
      department: "Product",
      email: "aman@example.com",
      employment_type: "Full-time",
      date_of_joining: Date.new(2022, 5, 10)
    )

    FactoryBot.create(
      :employee,
      full_name: "John Smith",
      job_title: "QA Engineer",
      country: "USA",
      salary: 70000,
      department: "Quality",
      email: "john@example.com",
      employment_type: "Full-time",
      date_of_joining: Date.new(2021, 7, 15)
    )

    FactoryBot.create(
      :employee,
      full_name: "Alice Brown",
      job_title: "DevOps Engineer",
      country: "USA",
      salary: 160000,
      department: "Infrastructure",
      email: "alice@example.com",
      employment_type: "Full-time",
      date_of_joining: Date.new(2020, 3, 20)
    )

    FactoryBot.create(
      :employee,
      full_name: "Emma Wilson",
      job_title: "HR Manager",
      country: "Canada",
      salary: 50000,
      department: "HR",
      email: "emma@example.com",
      employment_type: "Part-time",
      date_of_joining: Date.new(2024, 1, 12)
    )
  end

  describe ".overview" do
    subject(:overview) { described_class.overview }

    it "returns overall employee statistics" do
      expect(overview[:total_employees]).to eq(6)
      expect(overview[:total_countries]).to eq(3)
      expect(overview[:total_job_titles]).to eq(5)
      expect(overview[:overall_average_salary]).to eq(101666.67)
      expect(overview[:highest_salary]).to eq(160000)
      expect(overview[:lowest_salary]).to eq(50000)
    end

    it "returns employee count grouped by country" do
      expect(overview[:employee_count_by_country]).to eq({
        "India" => 3,
        "USA" => 2,
        "Canada" => 1
      })
    end

    it "returns employee count grouped by department" do
      expect(overview[:employee_count_by_department]).to eq({
        "Engineering" => 2,
        "Product" => 1,
        "Quality" => 1,
        "Infrastructure" => 1,
        "HR" => 1
      })
    end

    it "returns average salary grouped by department" do
      expect(overview[:average_salary_by_department]).to eq({
        "Engineering" => 100000.0,
        "Product" => 130000.0,
        "Quality" => 70000.0,
        "Infrastructure" => 160000.0,
        "HR" => 50000.0
      })
    end

    it "returns top 5 highest paying job titles" do
      expect(overview[:top_5_highest_paying_job_titles]).to eq({
        "DevOps Engineer" => 160000.0,
        "Product Manager" => 130000.0,
        "Software Engineer" => 100000.0,
        "QA Engineer" => 70000.0,
        "HR Manager" => 50000.0
      })
    end
  end

  describe ".by_country" do
    subject(:india_insights) { described_class.by_country("India") }

    it "returns country-specific salary insights" do
      expect(india_insights[:country]).to eq("India")
      expect(india_insights[:total_employees]).to eq(3)
      expect(india_insights[:minimum_salary]).to eq(90000)
      expect(india_insights[:maximum_salary]).to eq(130000)
      expect(india_insights[:average_salary]).to eq(110000.0)
    end

    it "returns average salary grouped by department for the country" do
      expect(india_insights[:average_salary_by_department]).to eq({
        "Engineering" => 100000.0,
        "Product" => 130000.0
      })
    end

    it "returns employee count grouped by job title for the country" do
      expect(india_insights[:employee_count_by_job_title]).to eq({
        "Software Engineer" => 2,
        "Product Manager" => 1
      })
    end

    it "returns salary distribution for the country" do
      expect(india_insights[:salary_distribution]).to eq({
        "0-50000" => 0,
        "50001-100000" => 1,
        "100001-150000" => 2,
        "150001+" => 0
      })
    end
  end

  describe ".by_country_and_job_title" do
    subject(:software_engineer_india) do
      described_class.by_country_and_job_title("India", "Software Engineer")
    end

    it "returns salary insights for a specific country and job title" do
      expect(software_engineer_india[:country]).to eq("India")
      expect(software_engineer_india[:job_title]).to eq("Software Engineer")
      expect(software_engineer_india[:total_employees]).to eq(2)
      expect(software_engineer_india[:minimum_salary]).to eq(90000)
      expect(software_engineer_india[:maximum_salary]).to eq(110000)
      expect(software_engineer_india[:average_salary]).to eq(100000.0)
    end
  end
end