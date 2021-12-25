/* freelancers with more than 10 responds */

WITH frelancer_with_responds_count AS (
	SELECT *, (SELECT COUNT(*) FROM respond r WHERE f.id = r.id) AS number_of_responds
	FROM freelancer f
)
SELECT * FROM frelancer_with_responds_count WHERE number_of_responds > 10;

/* customers with more than 10 projects */

WITH customer_with_projects_count AS (
	SELECT *, (SELECT COUNT(*) FROM project p WHERE c.id = p.id) AS number_of_projects
	FROM customer c
)
SELECT * FROM customer_with_projects_count WHERE number_of_projects > 10;
