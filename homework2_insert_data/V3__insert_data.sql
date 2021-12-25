INSERT INTO account(id, first_name, last_name, email, description, account_type) 
	VALUES (1, 'Aidar', 'Ibragimov', 'ibragimovaidarp@gmail.com', 'Java developer from Kazan', 'freelancer');

INSERT INTO account(id, first_name, last_name, email, description, account_type) 
	VALUES (2, 'Ivan', 'Ivanov', 'ivan.ivanov@gmail.com', '', 'customer');

INSERT INTO project(id, description, price, hours_to_complete, category_id, account_id) VALUES (1, 'Android application', 500, 10, 1, 2);

INSERT INTO respond(price, hours_to_complete, description, project_id, freelancer_id) 
	VALUES (800, 30, 'some description', 1, 1);

INSERT INTO freelance_order (customer_id, freelancer_id, project_id, status)
	VALUES (2, 1, 1, 'ON_PROCESS');
