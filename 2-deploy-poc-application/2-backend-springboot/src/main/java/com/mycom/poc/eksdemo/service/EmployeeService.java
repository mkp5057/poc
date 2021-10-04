package com.mycom.poc.eksdemo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.mycom.poc.eksdemo.dto.EmployeeDTO;
import com.mycom.poc.eksdemo.exception.EmployeeNotFoundException;
import com.mycom.poc.eksdemo.model.Employee;
import com.mycom.poc.eksdemo.repository.EmployeeRepository;

@Component
public class EmployeeService {

	@Autowired
	EmployeeRepository employeeRepository;

	public Iterable<Employee> findAll() {
		return employeeRepository.findAll();
	}

	public Employee save(EmployeeDTO employeedto) {
		Employee employee = new Employee(employeedto.getName(), employeedto.getDesignation(), employeedto.getSalary());
		return employeeRepository.save(employee);
	}

	public Employee findByID(Long id) {
		return employeeRepository.findById(id).orElseThrow(() -> new EmployeeNotFoundException(id));
	}

	public Employee update(Long empid, EmployeeDTO employeedto) {
		Employee employee = employeeRepository.findById(empid).orElse(null);

		employee.setName(employeedto.getName());
		employee.setDesignation(employeedto.getDesignation());
		employee.setSalary(employeedto.getSalary());
		return employeeRepository.save(employee);
	}

	public void delete(Long empId) {
		employeeRepository.deleteById(empId);
	}
}
