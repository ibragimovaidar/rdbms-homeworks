/*
Для этого домашнего задания я использовал схему данных из дз 8 
т.к не нашёл применения материализованным представлениям у себя в предметной области.
 
 Домашнее задание начинается со строки 116
*/

DROP TABLE IF EXISTS airport CASCADE;
DROP TABLE IF EXISTS airplane CASCADE;
DROP TABLE IF EXISTS pilot CASCADE;
DROP TABLE IF EXISTS flight CASCADE;
DROP TABLE IF EXISTS passanger CASCADE;
DROP TABLE IF EXISTS crew_member CASCADE;
DROP TABLE IF EXISTS flights_crew_members CASCADE;
DROP TABLE IF EXISTS flights_passangers CASCADE;
DROP TYPE IF EXISTS flight_status;
DROP TYPE IF EXISTS crew_member_type;

CREATE TABLE airport (
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	city VARCHAR(64) NOT NULL
);

CREATE TABLE airplane (
	id SERIAL PRIMARY KEY,
	model VARCHAR(128) NOT NULL,
	passangers_capacity INTEGER NOT NULL
);


CREATE TABLE pilot (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(40) NOT NULL,
	last_name VARCHAR(60) NOT NULL,
	patronymic VARCHAR(60) NOT NULL,
	CHECK (LENGTH(first_name) > 2),
	CHECK (LENGTH(last_name) > 2)
); 

CREATE TYPE flight_status AS ENUM ('planned', 'canceled', 'in process', 'completed');

CREATE TABLE flight (
	id SERIAL PRIMARY KEY,
	aiplane_id INTEGER REFERENCES airplane(id),
	status flight_status NOT NULL DEFAULT 'planned',
	pilot_id INTEGER REFERENCES pilot(id),
	departure INTEGER REFERENCES airport(id),
	destination INTEGER REFERENCES airport(id),
	departure_date DATE NOT NULL,
	departure_time TIME NOT NULL,
	arrival_date DATE NOT NULL,
	arrival_time TIME NOT NUll,
	CHECK ((arrival_date > departure_date) OR (arrival_date = departure_date AND arrival_time > departure_time)),
	CHECK (departure != destination)
);

CREATE TABLE passanger (
	id SERIAL PRIMARY KEY,
	passport_serial_number VARCHAR(20) UNIQUE NOT NULL,
	first_name VARCHAR(40) NOT NULL,
	last_name VARCHAR(60) NOT NULL,
	patonymic VARCHAR(60) NOT NULL,
	CHECK (LENGTH(first_name) > 2),
	CHECK (LENGTH(last_name) > 2)
);

CREATE TABLE flights_passangers (
	flight_id INTEGER REFERENCES flight(id),
	passanger_id INTEGER REFERENCES passanger(id),
	PRIMARY KEY(flight_id, passanger_id)
);

CREATE TYPE crew_member_type AS ENUM ('stewardess', 'technician');

CREATE TABLE crew_member(
	ID SERIAL PRIMARY KEY,
	first_name VARCHAR(40) NOT NULL,
	last_name VARCHAR(60) NOT NULL,
	patonymic VARCHAR(60) NOT NULL,
	type crew_member_type NOT NULL,
	CHECK (LENGTH(first_name) > 2),
	CHECK (LENGTH(last_name) > 2)
);

CREATE TABLE flights_crew_members (
	flight_id INTEGER REFERENCES flight(id),
	crew_member_id INTEGER REFERENCES crew_member(id),
	PRIMARY KEY(flight_id, crew_member_id)
);


INSERT INTO airport(name, city) VALUES ('Kazan airport', 'Kazan');
INSERT INTO airport(name, city) VALUES ('Moscow airport', 'Moscow');
INSERT INTO airport(name, city) VALUES ('Vancouver airport', 'Vancouver');
INSERT INTO airport(name, city) VALUES ('Prague airport', 'Prague');
INSERT INTO airport(name, city) VALUES ('Bucharest airport', 'Bucharest');
INSERT INTO airport(name, city) VALUES ('Macau airport', 'Macau');

INSERT INTO airplane(model, passangers_capacity) VALUES ('Boeing 737-300', 215);
INSERT INTO airplane(model, passangers_capacity) VALUES ('Boeing 727', 200);
INSERT INTO airplane(model, passangers_capacity) VALUES ('Boeing 707', 85);

INSERT INTO pilot(first_name, last_name, patronymic) VALUES ('Ivan', 'Ivanov', 'Ivanovich');
INSERT INTO pilot(first_name, last_name, patronymic) VALUES ('Dmitry', 'Grusha', 'Orogodovich');
INSERT INTO pilot(first_name, last_name, patronymic) VALUES ('Elena', 'Boing', 'Mikhailovna');

INSERT INTO flight(aiplane_id, pilot_id, departure, destination, departure_date, departure_time, arrival_date, arrival_time) 
VALUES (1, 2, 1, 4, '2021-11-01', '14:00', '2021-11-01', '18:00');
INSERT INTO flight(aiplane_id, pilot_id, departure, destination, departure_date, departure_time, arrival_date, arrival_time) 
VALUES (1, 2, 4, 5, '2021-11-03', '13:00', '2021-11-03', '16:00');
INSERT INTO flight(aiplane_id, pilot_id, departure, destination, departure_date, departure_time, arrival_date, arrival_time)
VALUES (1, 2, 5, 1, '2021-11-01', '13:00', '2021-11-02', '1:00');


/*дз: 
1) добавить ограничения ко всем таблицам и объяснить для чего они
2) создать 2-3 materialized view применительно к вашим системам
*/

/*
materialized view 1
т.к статус полета меняется на завершенный редко, можно обновлять список завершенных только при изменении статуса полета на завершенный,
а их список хранить в материализованном представлении 
*/

DROP MATERIALIZED VIEW IF EXISTS completed_flight;
DROP TRIGGER IF EXISTS completed_flight_trigger ON flight;
DROP FUNCTION IF EXISTS update_completed_flight();

CREATE MATERIALIZED VIEW completed_flight AS SELECT * FROM flight WHERE status = 'completed';

CREATE FUNCTION update_completed_flight() RETURNS TRIGGER AS $completed_flight$
BEGIN
    IF (TG_OP = 'UPDATE' AND NEW.status = 'completed') THEN
        REFRESH MATERIALIZED VIEW completed_flight;
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$completed_flight$ LANGUAGE plpgsql;
CREATE TRIGGER completed_flight_trigger
    AFTER UPDATE ON flight
    FOR EACH ROW EXECUTE PROCEDURE update_completed_flight();


/*
materialized view 2
Можно хранить полеты за прошедший год в materialized view 
*/
CREATE MATERIALIZED VIEW flight_2020 AS SELECT * FROM flight WHERE departure_date >= '2020-01-01' AND arrival_date <= '2020-12-31';
