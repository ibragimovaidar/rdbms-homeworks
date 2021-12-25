CREATE VIEW freelancer
AS SELECT * FROM account
WHERE account_type = 'freelancer'
WITH CASCADED CHECK OPTION;

CREATE VIEW customer
AS SELECT * FROM account
WHERE account_type = 'customer'
WITH CASCADED CHECK OPTION;

CREATE VIEW on_progress_freelance_order
AS SELECT * FROM freelance_order
WHERE status_id = 1
WITH CASCADED CHECK OPTION;


CREATE VIEW verification_freelance_order
AS SELECT * FROM freelance_order
WHERE status_id = 2
WITH CASCADED CHECK OPTION;

CREATE VIEW closed_freelance_order
AS SELECT * FROM freelance_order
WHERE status_id = 3
WITH CASCADED CHECK OPTION;
