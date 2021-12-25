-- inner join
SELECT r.id as respond_id FROM account a JOIN respond r ON a.id = r.freelancer_id;

SELECT p.id as project_id FROM account a JOIN project p ON a.id = p.account_id;

SELECT a.id as account_id, o.id as order_id, o.respond_id as respond_id, o.project_id as project_id, o.freelancer_id as freelancer_id
	FROM account a JOIN freelance_order o ON a.id = o.customer_id 
	WHERE o.status = 'COMPLETED';

--left/right
SELECT p.id as project_id FROM account a  JOIN project p ON a.id = p.account_id;

--cross
SELECT * FROM account CROSS JOIN project;

--natural
SELECT  * FROM account NATURAL JOIN freelance_order;

--semi
/* id акаунтов у которых есть хотя бы 1 проект */
SELECT a.id as account_id FROM account a WHERE 
	EXISTS (SELECT 1 FROM project p WHERE a.id = p.account_id)

--anti
/* id аккаунтов у которых нет ни одного проекта */
SELECT a.id as account_id FROM account a WHERE 
	NOT EXISTS (SELECT 1 FROM project p WHERE a.id = p.account_id);
/* id аккаунтов у которых нет ни одного отклика */
SELECT a.id as account_id FROM account a WHERE 
	NOT EXISTS (SELECT 1 FROM respond r WHERE a.id = r.freelancer_id);
