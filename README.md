# 💼 Salary Management System - Backend (Rails API)

## 🚀 Overview

This is the backend service for the Salary Management System. It provides RESTful APIs to manage employee records and generate salary insights for an organization with 10,000+ employees.

---

## 🛠️ Tech Stack

* Ruby on Rails (API mode)
* PostgreSQL
* RSpec (Testing)
* Render (Deployment)

---

## ⚙️ Features

### 👨‍💼 Employee Management

* Create Employee
* View Employees
* Update Employee
* Delete Employee

### 📊 Salary Insights

* Average Salary by Country
* Average Salary by Job Title
* Highest & Lowest Salary
* Department-wise Salary Analysis

---

## 📦 API Endpoints

### Employees

```
GET    /api/v1/employees
POST   /api/v1/employees
GET    /api/v1/employees/:id
PUT    /api/v1/employees/:id
DELETE /api/v1/employees/:id
```

### Insights

```
GET /api/v1/insights
```

---

## 🌱 Seed Data (10,000 Employees)

* Generated using first_names.txt & last_names.txt
* Optimized for performance
* Ensures realistic dataset for testing

---

## 🧪 Testing

* RSpec test cases implemented
* Covers models, controllers, and core business logic

Run tests:

```bash
bundle exec rspec
```

---

## 🚀 Deployment

* Hosted on Render
* Live API: https://i-salary-management.onrender.com/api/v1/employees

---

## ⚡ Performance Considerations

* Pagination-ready APIs
* Efficient DB queries
* Optimized seed script for large datasets

---

## 🧠 Engineering Decisions

* Used Rails API mode for clean separation of concerns
* Structured controllers and services for maintainability
* Focused on scalability (10k+ records handling)

---

## 📌 Future Improvements

* Authentication (JWT)
* Caching (Redis)
* Background jobs (Sidekiq)
* Advanced filtering & search

---

## 👨‍💻 Author

Rajiv Chaurasia
