/**
 * Employee Management System - Frontend JavaScript
 * 
 * Architecture: 3-Tier
 * - Frontend (This file): Runs in browser
 * - Backend (Spring Boot): REST API on server
 * - Database (MySQL): Data storage
 * 
 * This file handles:
 * - User interactions (clicks, form submissions)
 * - API calls to backend
 * - DOM updates
 * - Error handling
 */

// ═══════════════════════════════════════════════════════════════════
// CONFIGURATION
// ═══════════════════════════════════════════════════════════════════

const API_BASE_URL = 'http://localhost:8080/api/employees';

// ═══════════════════════════════════════════════════════════════════
// PAGE INITIALIZATION
// ═══════════════════════════════════════════════════════════════════

document.addEventListener('DOMContentLoaded', function() {
    console.log('✓ DOM Loaded - Initializing Employee Management System');
    
    // Load all employees on page load
    getAllEmployees();
    
    // Form submission
    document.getElementById('employeeForm').addEventListener('submit', createEmployee);
    document.getElementById('editForm').addEventListener('submit', updateEmployee);
    
    // Modal close button
    document.querySelector('.close').addEventListener('click', closeModal);
    
    // Close modal when clicking outside
    window.addEventListener('click', function(event) {
        const modal = document.getElementById('editModal');
        if (event.target === modal) {
            closeModal();
        }
    });
});

// ═══════════════════════════════════════════════════════════════════
// FETCH ALL EMPLOYEES
// ═══════════════════════════════════════════════════════════════════

function getAllEmployees() {
    console.log('[FRONTEND] Fetching all employees from API');
    
    showLoading();
    
    fetch(API_BASE_URL)
        .then(response => {
            console.log('[FRONTEND] API Response Status:', response.status);
            if (!response.ok) {
                throw new Error('Failed to fetch employees: ' + response.statusText);
            }
            return response.json();
        })
        .then(data => {
            console.log('[FRONTEND] Received data:', data);
            
            if (data.success) {
                displayEmployees(data.data);
                showMessage('Employees loaded successfully', 'success', 'employeeList');
            } else {
                showMessage('Error: ' + data.error, 'error', 'employeeList');
            }
            hideLoading();
        })
        .catch(error => {
            console.error('[FRONTEND] Error:', error);
            showMessage('Error: Unable to connect to server. Make sure backend is running on localhost:8080', 'error', 'employeeList');
            hideLoading();
        });
}

// ═══════════════════════════════════════════════════════════════════
// DISPLAY EMPLOYEES IN TABLE
// ═══════════════════════════════════════════════════════════════════

function displayEmployees(employees) {
    const employeeList = document.getElementById('employeeList');
    const countInfo = document.getElementById('employeeCount');
    
    console.log('[FRONTEND] Displaying', employees.length, 'employees');
    
    if (!employees || employees.length === 0) {
        employeeList.innerHTML = '<tr><td colspan="8" class="text-center">No employees found</td></tr>';
        countInfo.innerHTML = '📊 Total: 0 employees';
        return;
    }
    
    // Build table rows
    let html = '';
    employees.forEach(emp => {
        html += `
            <tr>
                <td>${emp.id}</td>
                <td>${emp.name}</td>
                <td>${emp.email}</td>
                <td>$${emp.salary ? emp.salary.toFixed(2) : '0.00'}</td>
                <td>${emp.department || '-'}</td>
                <td>${emp.phone || '-'}</td>
                <td>${emp.joiningDate || '-'}</td>
                <td>
                    <div class="table-actions">
                        <button class="btn btn-edit" onclick="editEmployee(${emp.id})">✏️ Edit</button>
                        <button class="btn btn-danger" onclick="deleteEmployee(${emp.id})">🗑️ Delete</button>
                    </div>
                </td>
            </tr>
        `;
    });
    
    employeeList.innerHTML = html;
    countInfo.innerHTML = `📊 Total: <strong>${employees.length}</strong> employee(s)`;
}

// ═══════════════════════════════════════════════════════════════════
// CREATE NEW EMPLOYEE
// ═══════════════════════════════════════════════════════════════════

function createEmployee(event) {
    event.preventDefault();
    console.log('[FRONTEND] Creating new employee');
    
    // Get form data
    const formData = {
        name: document.getElementById('name').value.trim(),
        email: document.getElementById('email').value.trim(),
        salary: parseFloat(document.getElementById('salary').value) || 0,
        department: document.getElementById('department').value.trim(),
        phone: document.getElementById('phone').value.trim(),
        joiningDate: document.getElementById('joiningDate').value
    };
    
    console.log('[FRONTEND] Employee Data:', formData);
    
    // Validation
    if (!formData.name) {
        showMessage('Please enter employee name', 'warning', 'addMessage');
        return;
    }
    if (!formData.email) {
        showMessage('Please enter employee email', 'warning', 'addMessage');
        return;
    }
    
    // Send to API
    fetch(API_BASE_URL, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData)
    })
        .then(response => {
            console.log('[FRONTEND] Create Response Status:', response.status);
            if (!response.ok) {
                return response.json().then(error => {
                    throw new Error(error.error || 'Failed to create employee');
                });
            }
            return response.json();
        })
        .then(data => {
            console.log('[FRONTEND] Employee created:', data);
            showMessage('✓ Employee created successfully!', 'success', 'addMessage');
            document.getElementById('employeeForm').reset();
            getAllEmployees();
        })
        .catch(error => {
            console.error('[FRONTEND] Error creating employee:', error);
            showMessage('Error: ' + error.message, 'error', 'addMessage');
        });
}

// ═══════════════════════════════════════════════════════════════════
// SEARCH EMPLOYEES
// ═══════════════════════════════════════════════════════════════════

function searchEmployees() {
    const searchTerm = document.getElementById('searchInput').value.trim();
    
    if (!searchTerm) {
        showMessage('Please enter a search term', 'warning', 'employeeList');
        return;
    }
    
    console.log('[FRONTEND] Searching for:', searchTerm);
    
    showLoading();
    
    fetch(`${API_BASE_URL}/search?name=${encodeURIComponent(searchTerm)}`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                displayEmployees(data.data);
                showMessage(`Found ${data.count} employee(s)`, 'info', 'employeeList');
            } else {
                showMessage('Error: ' + data.error, 'error', 'employeeList');
            }
            hideLoading();
        })
        .catch(error => {
            console.error('[FRONTEND] Search error:', error);
            showMessage('Error: ' + error.message, 'error', 'employeeList');
            hideLoading();
        });
}

// ═══════════════════════════════════════════════════════════════════
// EDIT EMPLOYEE
// ═══════════════════════════════════════════════════════════════════

function editEmployee(id) {
    console.log('[FRONTEND] Loading employee for editing, ID:', id);
    
    fetch(`${API_BASE_URL}/${id}`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const emp = data.data;
                
                // Fill form with employee data
                document.getElementById('editId').value = emp.id;
                document.getElementById('editName').value = emp.name;
                document.getElementById('editEmail').value = emp.email;
                document.getElementById('editSalary').value = emp.salary;
                document.getElementById('editDepartment').value = emp.department || '';
                document.getElementById('editPhone').value = emp.phone || '';
                document.getElementById('editJoiningDate').value = emp.joiningDate || '';
                
                // Show modal
                openModal();
            } else {
                showMessage('Error: ' + data.error, 'error', 'employeeList');
            }
        })
        .catch(error => {
            console.error('[FRONTEND] Error loading employee:', error);
            showMessage('Error: ' + error.message, 'error', 'employeeList');
        });
}

function updateEmployee(event) {
    event.preventDefault();
    console.log('[FRONTEND] Updating employee');
    
    const id = document.getElementById('editId').value;
    
    const updatedData = {
        name: document.getElementById('editName').value.trim(),
        email: document.getElementById('editEmail').value.trim(),
        salary: parseFloat(document.getElementById('editSalary').value) || 0,
        department: document.getElementById('editDepartment').value.trim(),
        phone: document.getElementById('editPhone').value.trim(),
        joiningDate: document.getElementById('editJoiningDate').value
    };
    
    console.log('[FRONTEND] Updated Data:', updatedData);
    
    fetch(`${API_BASE_URL}/${id}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(updatedData)
    })
        .then(response => {
            if (!response.ok) {
                return response.json().then(error => {
                    throw new Error(error.error || 'Failed to update employee');
                });
            }
            return response.json();
        })
        .then(data => {
            console.log('[FRONTEND] Employee updated:', data);
            showMessage('✓ Employee updated successfully!', 'success', 'editMessage');
            setTimeout(() => {
                closeModal();
                getAllEmployees();
            }, 1000);
        })
        .catch(error => {
            console.error('[FRONTEND] Error updating employee:', error);
            showMessage('Error: ' + error.message, 'error', 'editMessage');
        });
}

// ═══════════════════════════════════════════════════════════════════
// DELETE EMPLOYEE
// ═══════════════════════════════════════════════════════════════════

function deleteEmployee(id) {
    if (!confirm('Are you sure you want to delete this employee?')) {
        return;
    }
    
    console.log('[FRONTEND] Deleting employee, ID:', id);
    
    fetch(`${API_BASE_URL}/${id}`, {
        method: 'DELETE'
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showMessage('✓ Employee deleted successfully!', 'success', 'employeeList');
                getAllEmployees();
            } else {
                showMessage('Error: ' + data.error, 'error', 'employeeList');
            }
        })
        .catch(error => {
            console.error('[FRONTEND] Error deleting employee:', error);
            showMessage('Error: ' + error.message, 'error', 'employeeList');
        });
}

// ═══════════════════════════════════════════════════════════════════
// MODAL FUNCTIONS
// ═══════════════════════════════════════════════════════════════════

function openModal() {
    document.getElementById('editModal').classList.add('show');
}

function closeModal() {
    document.getElementById('editModal').classList.remove('show');
    document.getElementById('editForm').reset();
    document.getElementById('editMessage').innerHTML = '';
}

// ═══════════════════════════════════════════════════════════════════
// MESSAGE DISPLAY
// ═══════════════════════════════════════════════════════════════════

function showMessage(message, type, elementId) {
    const element = document.getElementById(elementId);
    if (!element) return;
    
    const msgDiv = element.nextElementSibling?.classList?.contains('message') 
        ? element.nextElementSibling 
        : document.createElement('div');
    
    msgDiv.className = `message show ${type}`;
    msgDiv.innerHTML = message;
    
    if (!element.nextElementSibling?.classList?.contains('message')) {
        element.parentNode.insertBefore(msgDiv, element.nextSibling);
    }
    
    // Auto-hide after 5 seconds
    setTimeout(() => {
        msgDiv.classList.remove('show');
    }, 5000);
}

// ═══════════════════════════════════════════════════════════════════
// LOADING INDICATOR
// ═══════════════════════════════════════════════════════════════════

function showLoading() {
    document.getElementById('loadingSpinner').style.display = 'block';
}

function hideLoading() {
    document.getElementById('loadingSpinner').style.display = 'none';
}

// ═══════════════════════════════════════════════════════════════════
// UTILITY FUNCTIONS
// ═══════════════════════════════════════════════════════════════════

console.log('✓ Employee Management System initialized');
console.log('API URL:', API_BASE_URL);
console.log('Frontend is communicating with Backend on port 8080');
