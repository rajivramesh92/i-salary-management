FactoryBot.define do
  factory :employee do
    sequence(:full_name) { |n| "Employee #{n}" }
    job_title { "Software Engineer" }
    country { "India" }
    department { "Engineering" }
    salary { 90000 }
    sequence(:email) { |n| "employee#{n}@example.com" }
    employment_type { "Full-time" }
    date_of_joining { Date.new(2023, 1, 1) }
  end
end