class CreateEmployees < ActiveRecord::Migration[7.2]
  def change
    create_table :employees do |t|
      t.string :full_name, null: false
      t.string :job_title, null: false
      t.string :country, null: false
      t.decimal :salary, precision: 12, scale: 2, null: false
      t.string :department
      t.string :email
      t.string :employment_type
      t.date :date_of_joining

      t.timestamps
    end
    
    add_index :employees, :country
    add_index :employees, :job_title
    add_index :employees, [:country, :job_title]
    add_index :employees, :full_name
    add_index :employees, :email, unique: true
  end
end
