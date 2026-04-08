class SalaryInsightsService
  class << self
    def overview
      {
        total_employees: Employee.count,
        total_countries: Employee.distinct.count(:country),
        total_job_titles: Employee.distinct.count(:job_title),
        overall_average_salary: Employee.average(:salary).to_f.round(2),
        highest_salary: Employee.maximum(:salary),
        lowest_salary: Employee.minimum(:salary),
        employee_count_by_country: Employee.group(:country).count,
        employee_count_by_department: Employee.group(:department).count,
        average_salary_by_department: Employee.group(:department).average(:salary).transform_values { |v| v.to_f.round(2) },
        top_5_highest_paying_job_titles: Employee.group(:job_title)
                                                 .average(:salary)
                                                 .transform_values { |v| v.to_f.round(2) }
                                                 .sort_by { |_job_title, avg_salary| -avg_salary }
                                                 .first(5)
                                                 .to_h
      }
    end

    def by_country(country)
      employees = Employee.where(country: country)

      {
        country: country,
        total_employees: employees.count,
        minimum_salary: employees.minimum(:salary),
        maximum_salary: employees.maximum(:salary),
        average_salary: employees.average(:salary).to_f.round(2),
        average_salary_by_department: employees.group(:department)
                                               .average(:salary)
                                               .transform_values { |v| v.to_f.round(2) },
        employee_count_by_job_title: employees.group(:job_title).count,
        salary_distribution: salary_distribution(employees)
      }
    end

    def by_country_and_job_title(country, job_title)
      employees = Employee.where(country: country, job_title: job_title)

      {
        country: country,
        job_title: job_title,
        total_employees: employees.count,
        minimum_salary: employees.minimum(:salary),
        maximum_salary: employees.maximum(:salary),
        average_salary: employees.average(:salary).to_f.round(2)
      }
    end
    

    private

    def salary_distribution(scope)
      {
        "0-50000" => scope.where(salary: 0..50000).count,
        "50001-100000" => scope.where(salary: 50001..100000).count,
        "100001-150000" => scope.where(salary: 100001..150000).count,
        "150001+" => scope.where("salary > ?", 150000).count
      }
    end
  end
end