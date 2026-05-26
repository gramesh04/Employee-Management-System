package com.example.webapp.service;

import com.example.webapp.dto.EmployeeDTO;
import com.example.webapp.exception.ResourceNotFoundException;
import com.example.webapp.model.Employee;
import com.example.webapp.repository.EmployeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class EmployeeService {

    @Autowired
    private EmployeeRepository employeeRepository;

    @Transactional(readOnly = true)
    public List<EmployeeDTO> getAllEmployees() {
        List<Employee> employees = employeeRepository.findAll();
        
        return employees.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public EmployeeDTO getEmployeeById(Long id) {
        Employee employee = employeeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with id: " + id));
        
        return convertToDTO(employee);
    }

    public EmployeeDTO createEmployee(EmployeeDTO employeeDTO) {
        if (employeeRepository.findByEmail(employeeDTO.getEmail()).isPresent()) {
            throw new IllegalArgumentException("Email already exists: " + employeeDTO.getEmail());
        }
        
        if (employeeDTO.getName() == null || employeeDTO.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Employee name cannot be empty");
        }
        
        if (employeeDTO.getSalary() != null && employeeDTO.getSalary() < 0) {
            throw new IllegalArgumentException("Salary cannot be negative");
        }
        
        Employee employee = convertToEntity(employeeDTO);
        Employee savedEmployee = employeeRepository.save(employee);
        
        return convertToDTO(savedEmployee);
    }

    public EmployeeDTO updateEmployee(Long id, EmployeeDTO employeeDTO) {
        
        Employee employee = employeeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found with id: " + id));
        
        if (employeeDTO.getName() != null && !employeeDTO.getName().trim().isEmpty()) {
            employee.setName(employeeDTO.getName());
        }
        
        if (employeeDTO.getEmail() != null && !employeeDTO.getEmail().trim().isEmpty()) {
            if (!employee.getEmail().equals(employeeDTO.getEmail())) {
                if (employeeRepository.findByEmail(employeeDTO.getEmail()).isPresent()) {
                    throw new IllegalArgumentException("Email already exists: " + employeeDTO.getEmail());
                }
            }
            employee.setEmail(employeeDTO.getEmail());
        }
        
        if (employeeDTO.getSalary() != null && employeeDTO.getSalary() >= 0) {
            employee.setSalary(employeeDTO.getSalary());
        }
        
        if (employeeDTO.getDepartment() != null) {
            employee.setDepartment(employeeDTO.getDepartment());
        }
        
        if (employeeDTO.getPhone() != null) {
            employee.setPhone(employeeDTO.getPhone());
        }
        
        if (employeeDTO.getJoiningDate() != null) {
            employee.setJoiningDate(employeeDTO.getJoiningDate());
        }
        
        Employee updatedEmployee = employeeRepository.save(employee);
        
        return convertToDTO(updatedEmployee);
    }

    public void deleteEmployee(Long id) {
        if (!employeeRepository.existsById(id)) {
            throw new ResourceNotFoundException("Employee not found with id: " + id);
        }
        
        employeeRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public List<EmployeeDTO> getEmployeesByDepartment(String department) {
        List<Employee> employees = employeeRepository.findByDepartment(department);
        
        return employees.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<EmployeeDTO> searchEmployees(String name) {
        List<Employee> employees = employeeRepository.findByNameContainingIgnoreCase(name);
        
        return employees.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public long getTotalEmployeeCount() {
        return employeeRepository.count();
    }

    private EmployeeDTO convertToDTO(Employee employee) {
        EmployeeDTO dto = new EmployeeDTO();
        dto.setId(employee.getId());
        dto.setName(employee.getName());
        dto.setEmail(employee.getEmail());
        dto.setSalary(employee.getSalary());
        dto.setDepartment(employee.getDepartment());
        dto.setPhone(employee.getPhone());
        dto.setJoiningDate(employee.getJoiningDate());
        return dto;
    }

    private Employee convertToEntity(EmployeeDTO dto) {
        Employee employee = new Employee();
        employee.setName(dto.getName());
        employee.setEmail(dto.getEmail());
        employee.setSalary(dto.getSalary());
        employee.setDepartment(dto.getDepartment());
        employee.setPhone(dto.getPhone());
        employee.setJoiningDate(dto.getJoiningDate());
        return employee;
    }
}
