-- ═════════════════════════════════════════════════════════════════════
-- Employee Management System - Database Schema
-- ═════════════════════════════════════════════════════════════════════
-- 
-- Database: MySQL
-- Tables: employee
-- 
-- How to use:
-- 1. Connect to MySQL: mysql -u root -p
-- 2. Create database: CREATE DATABASE employee_db;
-- 3. Use database: USE employee_db;
-- 4. Run this script: source schema.sql
-- 
-- Or one line:
-- mysql -u root -p employee_db < schema.sql
-- ═════════════════════════════════════════════════════════════════════

-- ═════════════════════════════════════════════════════════════════════
-- CREATE DATABASE (if not exists)
-- ═════════════════════════════════════════════════════════════════════

CREATE DATABASE IF NOT EXISTS employee_db;
USE employee_db;

-- ═════════════════════════════════════════════════════════════════════
-- CREATE EMPLOYEE TABLE
-- ═════════════════════════════════════════════════════════════════════
-- 
-- This table stores employee information
-- 
-- Columns:
-- - id: Auto-increment primary key
-- - name: Employee name (required)
-- - email: Employee email (unique, required)
-- - salary: Employee salary
-- - department: Department name
-- - phone: Phone number
-- - joining_date: Date employee joined
-- - created_at: Record creation timestamp
-- - updated_at: Record update timestamp
-- ═════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS employee (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Employee ID',
    name VARCHAR(100) NOT NULL COMMENT 'Employee Name',
    email VARCHAR(100) UNIQUE NOT NULL COMMENT 'Email (unique)',
    salary DECIMAL(10, 2) COMMENT 'Salary in USD',
    department VARCHAR(50) COMMENT 'Department',
    phone VARCHAR(20) COMMENT 'Phone Number',
    joining_date VARCHAR(20) COMMENT 'Joining Date (YYYY-MM-DD)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Created Time',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Updated Time',
    INDEX idx_email (email),
    INDEX idx_department (department),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Employee Records';

-- ═════════════════════════════════════════════════════════════════════
-- INSERT SAMPLE DATA
-- ═════════════════════════════════════════════════════════════════════
-- 
-- Sample data to test application
-- ═════════════════════════════════════════════════════════════════════

INSERT INTO employee (name, email, salary, department, phone, joining_date) VALUES
('John Doe', 'john.doe@example.com', 50000, 'IT', '9876543210', '2023-01-15'),
('Jane Smith', 'jane.smith@example.com', 60000, 'HR', '9876543211', '2023-02-20'),
('Robert Johnson', 'robert.johnson@example.com', 55000, 'Sales', '9876543212', '2023-03-10'),
('Emily Brown', 'emily.brown@example.com', 65000, 'IT', '9876543213', '2023-04-05'),
('Michael Davis', 'michael.davis@example.com', 45000, 'Marketing', '9876543214', '2023-05-12');

-- ═════════════════════════════════════════════════════════════════════
-- VERIFY DATA
-- ═════════════════════════════════════════════════════════════════════

-- View all employees
-- SELECT * FROM employee;

-- Count employees
-- SELECT COUNT(*) as total_employees FROM employee;

-- View employees by department
-- SELECT * FROM employee WHERE department = 'IT';

-- ═════════════════════════════════════════════════════════════════════
-- QUERIES FOR APPLICATION
-- ═════════════════════════════════════════════════════════════════════

-- Get all employees
-- SELECT * FROM employee ORDER BY id DESC;

-- Get employee by ID
-- SELECT * FROM employee WHERE id = 1;

-- Get employee by email
-- SELECT * FROM employee WHERE email = 'john.doe@example.com';

-- Get employees by department
-- SELECT * FROM employee WHERE department = 'IT';

-- Search by name
-- SELECT * FROM employee WHERE name LIKE '%John%';

-- Get employees with salary >= 50000
-- SELECT * FROM employee WHERE salary >= 50000;

-- Create new employee
-- INSERT INTO employee (name, email, salary, department, phone, joining_date)
-- VALUES ('New Employee', 'new@example.com', 55000, 'IT', '9999999999', '2024-01-01');

-- Update employee
-- UPDATE employee SET salary = 65000, department = 'Management' WHERE id = 1;

-- Delete employee
-- DELETE FROM employee WHERE id = 1;

-- ═════════════════════════════════════════════════════════════════════
-- DATABASE STATISTICS
-- ═════════════════════════════════════════════════════════════════════

-- Show table structure
-- DESCRIBE employee;
-- SHOW CREATE TABLE employee;

-- Show table size
-- SELECT 
--   table_name, 
--   round(((data_length + index_length) / 1024 / 1024), 2) AS size_mb
-- FROM information_schema.TABLES
-- WHERE table_schema = 'employee_db';

-- ═════════════════════════════════════════════════════════════════════
-- END OF SCHEMA
-- ═════════════════════════════════════════════════════════════════════
