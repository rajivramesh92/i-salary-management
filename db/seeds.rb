# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "securerandom"

puts "🌱 Seeding employees..."

first_names_path = Rails.root.join("db/seeds/first_names.txt")
last_names_path  = Rails.root.join("db/seeds/last_names.txt")

first_names = File.readlines(first_names_path, chomp: true)
last_names  = File.readlines(last_names_path, chomp: true)

countries = [
  "India", "USA", "UK", "Germany", "Canada",
  "Australia", "Singapore", "UAE", "France", "Netherlands"
]

job_titles = [
  "Software Engineer", "Senior Software Engineer", "Engineering Manager",
  "Product Manager", "HR Manager", "Data Analyst", "QA Engineer",
  "DevOps Engineer", "UI/UX Designer", "Sales Manager"
]

departments = [
  "Engineering", "Product", "HR", "Design",
  "Sales", "Operations", "Finance", "Marketing"
]

employment_types = [
  "Full-time", "Part-time", "Contract", "Intern"
]

Employee.delete_all

records = []

10_000.times do |i|
  first_name = first_names.sample
  last_name  = last_names.sample
  full_name  = "#{first_name} #{last_name}"

  email = "#{first_name.downcase}.#{last_name.downcase}.#{i}@example.com"

  records << {
    full_name: full_name,
    job_title: job_titles.sample,
    country: countries.sample,
    salary: rand(30_000..200_000),
    department: departments.sample,
    email: email,
    employment_type: employment_types.sample,
    date_of_joining: rand(Date.new(2018, 1, 1)..Date.today),
    created_at: Time.current,
    updated_at: Time.current
  }
end

Employee.insert_all(records)

puts "✅ Seeded #{Employee.count} employees successfully!"