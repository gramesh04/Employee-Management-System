package com.example.webapp.controller;

import com.example.webapp.dto.EmployeeDTO;
import com.example.webapp.exception.ResourceNotFoundException;
import com.example.webapp.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/employees")
@CrossOrigin(origins = "*", maxAge = 3600)
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;

    @GetMapping
    public ResponseEntity<Map<String, Object>> getAllEmployees() {
        try {
            List<EmployeeDTO> employees = employeeService.getAllEmployees();
            long totalCount = employeeService.getTotalEmployeeCount();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Employees fetched successfully");
            response.put("totalCount", totalCount);
            response.put("data", employees);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return errorResponse("Failed to fetch employees: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getEmployeeById(@PathVariable Long id) {
        try {
            EmployeeDTO employee = employeeService.getEmployeeById(id);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Employee fetched successfully");
            response.put("data", employee);
            
            return ResponseEntity.ok(response);
        } catch (ResourceNotFoundException e) {
            return errorResponse(e.getMessage(), HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return errorResponse("Failed to fetch employee: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/search")
    public ResponseEntity<Map<String, Object>> searchEmployees(@RequestParam String name) {
        try {
            List<EmployeeDTO> employees = employeeService.searchEmployees(name);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Employees searched successfully");
            response.put("count", employees.size());
            response.put("data", employees);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return errorResponse("Search failed: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/department/{department}")
    public ResponseEntity<Map<String, Object>> getByDepartment(@PathVariable String department) {
        try {
            List<EmployeeDTO> employees = employeeService.getEmployeesByDepartment(department);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Employees fetched by department");
            response.put("department", department);
            response.put("count", employees.size());
            response.put("data", employees);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return errorResponse("Failed to fetch employees: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> createEmployee(@RequestBody EmployeeDTO employeeDTO) {
        try {
            EmployeeDTO createdEmployee = employeeService.createEmployee(employeeDTO);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Employee created successfully");
            response.put("data", createdEmployee);
            
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (IllegalArgumentException e) {
            return errorResponse(e.getMessage(), HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            return errorResponse("Failed to create employee: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateEmployee(
            @PathVariable Long id,
            @RequestBody EmployeeDTO employeeDTO) {
        
        try {
            EmployeeDTO updatedEmployee = employeeService.updateEmployee(id, employeeDTO);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Employee updated successfully");
            response.put("data", updatedEmployee);
            
            return ResponseEntity.ok(response);
        } catch (ResourceNotFoundException e) {
            return errorResponse(e.getMessage(), HttpStatus.NOT_FOUND);
        } catch (IllegalArgumentException e) {
            return errorResponse(e.getMessage(), HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            return errorResponse("Failed to update employee: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteEmployee(@PathVariable Long id) {
        try {
            employeeService.deleteEmployee(id);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Employee deleted successfully");
            response.put("deletedId", id);
            
            return ResponseEntity.ok(response);
        } catch (ResourceNotFoundException e) {
            return errorResponse(e.getMessage(), HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return errorResponse("Failed to delete employee: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "UP");
        response.put("message", "Employee Management Application is running");
        return ResponseEntity.ok(response);
    }

    private ResponseEntity<Map<String, Object>> errorResponse(String message, HttpStatus status) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("error", message);
        response.put("timestamp", System.currentTimeMillis());
        return ResponseEntity.status(status).body(response);
    }
}
