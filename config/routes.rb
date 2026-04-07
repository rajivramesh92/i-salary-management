Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :employees

      get "salary_insights", to: "salary_insights#index"
      get "salary_insights/by_country", to: "salary_insights#by_country"
      get "salary_insights/by_country_and_job_title", to: "salary_insights#by_country_and_job_title"
    end
  end
end