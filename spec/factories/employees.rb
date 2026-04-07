FactoryBot.define do
  factory :employee do
    full_name { "MyString" }
    job_title { "MyString" }
    country { "MyString" }
    department { "MyString" }
    salary { "9.99" }
    hire_date { "2026-04-07" }
    employment_status { "MyString" }
  end
end
