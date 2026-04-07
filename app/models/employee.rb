class Employee < ApplicationRecord

  validates :full_name, presence: true
  validates :job_title, presence: true
  validates :country,   presence: true

  validates :salary,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
              allow_nil: false  
            }

  
  validates :full_name, length: { minimum: 2, maximum: 100 }
  validates :job_title, length: { minimum: 2, maximum: 80 }
  validates :country,   length: { minimum: 2, maximum: 50 }


  scope :search_by_name, ->(query) {
    return all if query.blank?
    where("LOWER(full_name) LIKE ?", "%#{query.downcase}%")
  }

  scope :by_country, ->(country) {
    return all if country.blank?
    where(country: country)
  }

  scope :by_job_title, ->(job_title) {
    return all if job_title.blank?
    where(job_title: job_title)
  }
end
