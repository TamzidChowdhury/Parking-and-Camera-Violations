CREATE DATABASE Assignment2;
USE Assignment2;

CREATE TABLE TICKETS (
	plate text(20),
    state text(3),
    license_type text(10),
    summons_number INT(20) primary key,
    issue_date date,
    violation_time date,
    violation text(250),
    fine_amount decimal(10),
    penalty_amount decimal(10),
    interest_amount decimal(10),
    reduction_amount decimal(10),
    payment_amount decimal(10),
    amount_due decimal(10),
    precinct text(4),
    county text(4),
    issuing_agency text(25),
    violation_status text(50),
    summons_image text(300)
);


-- Loading the data into the database
LOAD DATA LOCAL INFILE "/Users/chowdhuryhaider/Downloads/Violations-Large.csv"
into table tickets
fields terminated by ',' 
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- Question 1: Identify the number of violations for a 2 month period. Display 1 row with the number of 
-- violations.

SELECT FORMAT(COUNT(summons_number), 'No') as 'Number of Violations' FROM tickets
WHERE issue_date <= '2021-09-15';

-- Question 2: Identify the violations by county. Display 3 columns: county, number of violations, total fine 
-- amount. The county with the largest number of violations is displayed first. Display 1 row for each 
-- distinct county. 

SELECT 
	county,
    FORMAT(COUNT(summons_number), 'NO') as number_of_violations,
    concat('$', format(SUM(fine_amount), 2)) as total_fines
FROM tickets
	group by county
    order by count(summons_number) desc;
    
-- Question 3: Identify the violations by license plate. Display 4 columns: License plate, license state, 
-- number of violations and total cost. The license plate with the most violatios is displayed first. 
-- Display 1 row for each distinct license plate.

SELECT 
	plate,
    state,
    FORMAT(COUNT(summons_number), 'NO') as number_of_violations,
    concat('$', format(SUM(fine_amount), 2)) as total_fines
FROM tickets
	group by plate,state
    order by count(summons_number) desc;

-- Question 4: Identify the violations by license type. Display columns: license type, number of violations 
-- and total fine amount. The license type with the most violations is displayed first.  Display 1 row for 
-- each distinct license type.

SELECT 
	license_type,
    FORMAT(COUNT(summons_number), 'NO') as number_of_violations,
    concat('$', format(SUM(fine_amount), 2)) as total_fines
FROM tickets
	group by license_type
    order by count(summons_number) desc;

-- Question 5: Identify violations by license plate state. Display columns: state, number of violations and 
-- total fine amount. The state with the most violations is displayed first. Display 1 row for each distinct 
-- state.

SELECT 
    state,
    FORMAT(COUNT(summons_number), 'NO') as number_of_violations,
    concat('$', format(SUM(fine_amount), 2)) as total_fines
FROM tickets
	group by state
    order by count(summons_number) desc;

-- Question 6: Identify crosswalk violations by year. Display 2 columns: year and number of violations. 
-- Order by year.

SELECT EXTRACT(year FROM issue_date) as YEAR, count(violation) as Number_of_Violations
FROM tickets
WHERE violation = 'Crosswalk' 
group by EXTRACT(year FROM issue_date)
order by Extract(year FROM issue_date) ASC;

-- Question 7: Identify violations for the last 2 months. Display 3 columns: violation, number of violations 
-- and total cost. The most violations will be displayed first. Display 1 row for each distinct violation.

SELECT violation as violation_type,
FORMAT(COUNT(summons_number), 'NO') as number_of_violations, 
concat('$', format(sum(fine_amount), 2)) as Total_Fine from tickets
where issue_date<='2021-09-15'
group by violation
order by count(summons_number) desc;

-- Question 8: Identify total fines for crosswalk. Display the total fines.

SELECT concat('$', format(SUM(fine_amount), 2)) as total_fine FROM tickets
	WHERE violation='CROSSWALK';

-- Question 9:  Identify the amount of fines given by each agency. Display 2 columns: agency name, and total 
-- fine amount. Agency with the highest fine should be at the top.

SELECT 
	issuing_agency,
    concat('$', format(SUM(fine_amount), 2)) as total_fine
FROM tickets
	group by issuing_agency
    order by 2 desc;
    
-- Question 10: Display the structure of ALL tables using SQL Describe.

DESCRIBE tickets;

-- Question 11: Display the version of MySQL.

SELECT version() ;




