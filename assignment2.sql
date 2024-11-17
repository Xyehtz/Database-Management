-- Question 1
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