require 'rails_helper'

RSpec.describe Employee, type: :model do
  subject(:employee) do
    described_class.new(
      full_name: "Vikas Sharma",
      job_title: "Software Engineer",
      country: "India",
      salary: 90000
     )
    end

    describe "validations" do
    it "is valid with valid attributes" do
      expect(employee).to be_valid
    end

    it "is invalid without full_name" do
      employee.full_name = nil
      expect(employee).not_to be_valid
      expect(employee.errors[:full_name]).to include("can't be blank")
    end

    it "is invalid without job_title" do
      employee.job_title = nil
      expect(employee).not_to be_valid
      expect(employee.errors[:job_title]).to include("can't be blank")
    end

    it "is invalid without country" do
      employee.country = nil
      expect(employee).not_to be_valid
      expect(employee.errors[:country]).to include("can't be blank")
    end

    it "is invalid without salary" do
      employee.salary = nil
      expect(employee).not_to be_valid
      expect(employee.errors[:salary]).to include("can't be blank")
    end

    it "is invalid when full_name is too short" do
      employee.full_name = "A"
      expect(employee).not_to be_valid
      expect(employee.errors[:full_name]).to include("is too short (minimum is 2 characters)")
    end

    it "is invalid when full_name is too long" do
      employee.full_name = "A" * 101
      expect(employee).not_to be_valid
      expect(employee.errors[:full_name]).to include("is too long (maximum is 100 characters)")
    end

    it "is invalid when job_title is too long" do
      employee.job_title = "A" * 81
      expect(employee).not_to be_valid
      expect(employee.errors[:job_title]).to include("is too long (maximum is 80 characters)")
    end

    it "is invalid when country is too short" do
      employee.country = "A"
      expect(employee).not_to be_valid
      expect(employee.errors[:country]).to include("is too short (minimum is 2 characters)")
    end

    it "is invalid when country is too long" do
      employee.country = "A" * 51
      expect(employee).not_to be_valid
      expect(employee.errors[:country]).to include("is too long (maximum is 50 characters)")
    end
  end

  describe "scopes" do
    let!(:employee1) do
      Employee.create!(
        full_name: "Vikas Sharma",
        job_title: "Software Engineer",
        country: "India",
        salary: 90000
      )
    end

    let!(:employee2) do
      Employee.create!(
        full_name: "John Smith",
        job_title: "Product Manager",
        country: "USA",
        salary: 120000
      )
    end

    let!(:employee3) do
      Employee.create!(
        full_name: "Priya Patel",
        job_title: "Software Engineer",
        country: "India",
        salary: 95000
      )
    end

    describe ".search_by_name" do
      it "returns matching employees when query is present" do
        results = Employee.search_by_name("vikas")
        expect(results).to include(employee1)
        expect(results).not_to include(employee2, employee3)
      end

      it "returns all employees when query is blank" do
        results = Employee.search_by_name(nil)
        expect(results).to match_array([employee1, employee2, employee3])
      end
    end

    describe ".by_country" do
      it "returns employees matching the country" do
        results = Employee.by_country("India")
        expect(results).to match_array([employee1, employee3])
      end

      it "returns all employees when country is blank" do
        results = Employee.by_country(nil)
        expect(results).to match_array([employee1, employee2, employee3])
      end
    end

    describe ".by_job_title" do
      it "returns employees matching the job title" do
        results = Employee.by_job_title("Software Engineer")
        expect(results).to match_array([employee1, employee3])
      end

      it "returns all employees when job_title is blank" do
        results = Employee.by_job_title(nil)
        expect(results).to match_array([employee1, employee2, employee3])
      end
    end
  end
end