class ApplicationController < ActionController::API
   rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
   rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique


    private

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end
  def record_not_unique(_error)
    render json: { errors: ["Email has already been taken"] }, status: :unprocessable_entity
  end
end
