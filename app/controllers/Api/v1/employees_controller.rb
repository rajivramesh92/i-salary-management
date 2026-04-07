module Api
  module V1
    class EmployeesController < ApplicationController
      before_action :set_employee, only: [:show, :update, :destroy]

      def index
        employees = Employee
                      .search_by_name(params[:search])
                      .by_country(params[:country])
                      .by_job_title(params[:job_title])
                      .order(sort_column => sort_direction)
                      .page(params[:page])
                      .per(per_page)

        render json: {
          employees: employees.as_json,
          meta: {
            current_page: employees.current_page,
            total_pages: employees.total_pages,
            total_count: employees.total_count,
            per_page: employees.limit_value
          }
        }
      end

      def show
        render json: { employee: @employee }
      end

      def create
        employee = Employee.new(employee_params)

        if employee.save
          render json: { employee: employee }, status: :created
        else
          render json: { errors: employee.errors.to_hash(true) }, status: :unprocessable_entity
        end
      end

      def update
        if @employee.update(employee_params)
          render json: { employee: @employee }
        else
          render json: { errors: @employee.errors.to_hash(true) }, status: :unprocessable_entity
        end
      end

      def destroy
        @employee.destroy
        head :no_content
      end

      private

      def set_employee
        @employee = Employee.find(params[:id])
      end

      def employee_params
        params.require(:employee).permit(
          :full_name,
          :job_title,
          :country,
          :salary,
          :department,
          :email,
          :employment_type,
          :date_of_joining
        )
      end

      def sort_column
        allowed_columns = %w[full_name salary country job_title date_of_joining created_at]
        allowed_columns.include?(params[:sort]) ? params[:sort] : "created_at"
      end

      def sort_direction
        %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
      end

      def per_page
        page_size = params.fetch(:per_page, 20).to_i
        page_size.positive? ? [page_size, 100].min : 20
      end
    end
  end
end