-- Question 1
-- For every employee, retrieve their first name, last name, department name, and
-- the average salary of all employees who work in the same department and have
-- the same job title. (Using the tables: departments, employees and jobs).
select e.first_name,
       e.last_name,
       d.department_name,
       j.job_title,
       round(
          avg(e.salary)
          over(partition by e.job_id,
                            e.department_id),
          2
       ) as average_salary_per_department
  from employees e
  join hr.departments d
on d.department_id = e.department_id
  join hr.jobs j
on e.job_id = j.job_id;

-- Question 2
-- Return the name of the employees who have the 3rd highest salary.
select *
  from (
   select first_name,
          last_name,
          salary,
          dense_rank()
          over(
              order by salary desc
          ) as salary_rank
     from employees
) ranked_employees
 where salary_rank = 3;

-- Question 3
-- Find the row number for all employees in the marketing department.
select *
  from (
   select e.first_name,
          e.last_name,
          case
             when d.department_name = 'Marketing' then
                row_number()
                over(
                    order by e.first_name,
                             e.last_name
                )
          end as row_num_marketing
     from employees e
     join hr.departments d
   on d.department_id = e.department_id
) numbered_rows
 where row_num_marketing is not null;

-- Question 4
-- For each employee, return the difference between their salary and the average
-- salary of employees whose salaries range between $1000 and $5000
select e.first_name,
       e.last_name,
       e.salary,
       round(
          (e.salary -(
             select avg(salary)
               from employees
              where employees.salary between 1000 and 5000
          )),
          2
       ) as salary_difference
  from employees e;

-- Question 5
-- Write an SQL query that retrieves employee information, including employee ID,
-- first name, hire date, and salary. Calculate the average salary for each
-- employee, where the average salary represents the salary of the preceding
-- employee, and the following employee. The results should be ordered by hire date.
select e.employee_id,
       e.first_name,
       e.hire_date,
       e.salary,
       ( ( lag(e.salary)
           over(
           order by e.hire_date
           ) + lead(e.salary)
               over(
           order by e.hire_date
               ) ) / 2 ) as avg_salary
  from employees e
 order by hire_date;