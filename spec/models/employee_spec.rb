require 'rails_helper'

RSpec.describe Employee, type: :model do
  it "is valid with valid attributes" do
    employee = Employee.new(full_name: "Akhan Chaurasiya", job_title: "Ruby Developer", 
                           country: "India", salary: 1500000)
    expect(employee).to be_valid
  end

  it "is invalid without full_name" do
    employee = Employee.new(job_title: "Ruby Developer", country: "India", salary: 1500000)
    expect(employee).to_not be_valid
  end

  it "is invalid with negative salary" do
    employee = Employee.new(full_name: "Test", job_title: "Dev", country: "India", salary: -1000)
    expect(employee).to_not be_valid
  end
end