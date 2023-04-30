//Currently, a task can execute a single SQL statement, including a call to a stored procedure.|
//In summary tasks are very handy in Snowflake, they can be combined with streams,
-- snowpipe and other techniques to make them extremely powerful.

CREATE  DATABASE TESTING_TASK ;
DROP DATABASE TESTING_TASK;

USE TESTING_TASK;

CREATE OR REPLACE TABLE DEMO_TASK_TESTING
(ID INT AUTOINCREMENT START = 1 INCREMENT =1,
 NAME VARCHAR(40) DEFAULT  'TESTING',
 DATE TIMESTAMP
);

SELECT * FROM DEMO_TASK_TESTING;

// CREATING TASK 
CREATE OR REPLACE TASK INSERT_DATA_1MIN_INTERVAL
WAREHOUSE = COMPUTE_WH
SCHEDULE = '1 MINUTE'  
AS INSERT INTO DEMO_TASK_TESTING (DATE) VALUES(CURRENT_TIMESTAMP);

SHOW TASKS ;

ALTER TASK INSERT_DATA_1MIN_INTERVAL RESUME;
ALTER TASK INSERT_DATA_1MIN_INTERVAL SUSPEND;

/*Its In this format  = '0 5 * * *' (MIN HR DAY_OF_MONTH MONTH_OF_THE_YEAR DAY_OF_THE_WEEK)
In this example, the SCHEDULE parameter is set to '0 5 * * *', which corresponds to running the task every day at 
5 AM UTC.
In Snowflake, the Cron tab functionality is used to schedule tasks that need to be executed at 
a specific time or interval.

Snowflake provides a built-in scheduler that uses Cron syntax for scheduling tasks. 
The Snowflake scheduler allows users to schedule tasks to run at specific intervals, 
such as hourly, daily, weekly, or monthly. 

The syntax for scheduling tasks using Cron tab in Snowflake is similar to that used in Unix-like operating systems. */




----LET SEE THE TASK CREATE------

SHOW TASKS;

// WHEN U CREATE THE TASK BY DEFAULT IT IS SUSPENDED SO WE HAVE TO RESUME IT 
// TASK RESUME AND SUSPENDING
// TASK IS YOUR DDL COMMANDSO WE HAVE TO USE ALTER COMMAND

ALTER TASK INSERT_DATA_1MIN_INTERVAL RESUME;
ALTER TASK INSERT_DATA_1MIN_INTERVAL SUSPEND;

SELECT * FROM DEMO_VIDEO;

// DROP TASK

DROP TASK IF EXISTS INSERT_DATA_1MIN_INTERVAL;


CREATE OR REPLACE PROCEDURE UPDATE_THE_TABLE()
RETURNS TABLE (DATE TIMESTAMP)
LANGUAGE SQL
AS
$$ 
DECLARE
RES RESULTSET;
BEGIN
RES := (INSERT INTO DEMO_VIDEO (DATE) VALUES(CURRENT_TIMESTAMP));
RETURN TABLE(RES);
END;
$$;

CALL UPDATE_THE_TABLE();

SELECT * FROM DEMO_VIDEO;

CREATE OR REPLACE TASK RUN_AFTER_1MIN
WAREHOUSE = COMPUTE_WH
SCHEDULE ='1 MINUTE'
AS CALL UPDATE_THE_TABLE();

SHOW TASKS;

ALTER TASK RUN_AFTER_1MIN RESUME;
ALTER TASK RUN_AFTER_1MIN SUSPEND;




