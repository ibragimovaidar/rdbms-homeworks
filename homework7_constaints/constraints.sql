DROP TABLE IF EXISTS account_type;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS project;
DROP TABLE IF EXISTS respond;
DROP TABLE IF EXISTS freelance_order_status_type;
DROP TABLE IF EXISTS freelance_order;

CREATE TYPE account_type AS ENUM ('customer', 'freelancer'); 

CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(64)
);

CREATE TABlE account (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(64) NOT NULL,
    last_name VARCHAR(64) NOT NULL,
    email VARCHAR(64) NOT NULL UNIQUE,
    description TEXT,
    account_type account_type
);

CREATE TABLE project (
    id SERIAL PRIMARY KEY,
    description TEXT,
    price DECIMAL(8,2) NOT NULL,
    hours_to_complete INTEGER,
    category_id INTEGER REFERENCES category(id),
    account_id INTEGER REFERENCES account(id)
);

CREATE TABLE respond (
    id SERIAL PRIMARY KEY,
    price DECIMAL(8,2) NOT NULL,
    hours_to_complete INTEGER,
    description TEXT,
    project_id INTEGER REFERENCES project(id),
    freelancer_id INTEGER REFERENCES account(id)
);

CREATE TABLE freelance_order_status_type (
    id SERIAL PRIMARY KEY,
    status VARCHAR(20)
);

CREATE TYPE fleelance_order_status AS ENUM ('ON_PROCESS', 'CLOSED', 'CANCELED', 'VERIFICATION', 'SUSPENDED'); 

CREATE TABLE freelance_order (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES account(id),
    freelancer_id INTEGER REFERENCES account(id),
    project_id INTEGER REFERENCES project(id),
    respond_id INTEGER REFERENCES respond(id),
    status fleelance_order_status
);
