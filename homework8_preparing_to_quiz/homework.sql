-- 1) Построить физическую модель данных, которая максимально описывает начальные условия системы.
create table airport (
    id serial primary key,
    town varchar(20) not null
);

create table plane (
    id serial primary key,
    name varchar(20) not null
);

create table pilot (
    id serial primary key,
    first_name varchar(20) not null,
    last_name varchar(20) not null
);

create table stewardess (
    id serial primary key,
    first_name varchar(20) not null,
    last_name varchar(20) not null
);

create table engineer (
    id serial primary key,
    first_name varchar(20) not null,
    last_name varchar(20) not null
);

create table passenger (
    id serial primary key,
    first_name varchar(20) not null,
    last_name varchar(20) not null
);

create table crew (
    id serial primary key,
    pilot_id integer references pilot(id),
    stewardess_id integer references stewardess(id),
    engineers_id integer references engineer(id)
);

create table flight (
    id serial primary key,
    from_airport_id integer references airport(id),
    to_airport_id integer references airport(id),
    start_time timestamp,
    end_time timestamp,
    plane_id integer references plane(id),
    passenger_id integer references passenger(id),
    crew_id integer references crew(id)
);

-- 2) Заполнить получившиеся таблицы тестовыми данными (как минимум 3 аэропорта, 3 самолета и 10 рейсов).
insert into airport(town)
values ('Казань'),
       ('Москва'),
       ('Париж');

insert into plane(name)
values ('Boeing 777'),
       ('Boeing 737'),
       ('Boeing 747');

insert into pilot(first_name, last_name)
values ('Иванов', 'Иван'),
       ('Максимов', 'Максим'),
       ('Павлов', 'Павел');

insert into stewardess(first_name, last_name)
values ('Гончарова', 'Арина'),
       ('Сафонова', 'Ксения'),
       ('Степанова', 'Кира');

insert into engineer(first_name, last_name)
values ('Зубков', 'Антон'),
       ('Шишкин', 'Тимур'),
       ('Аксенов', 'Фёдор');

insert into passenger(first_name, last_name)
values ('Исаев', 'Константин'),
       ('Малышева', 'Мария'),
       ('Матвее', 'Богдан');

insert into crew(pilot_id, stewardess_id, engineers_id)
values (1, 1, 1),
       (2, 2, 2),
       (3, 3, 3);

insert into flight(from_airport_id, to_airport_id, start_time, end_time, plane_id, passenger_id, crew_id)
values (1, 2, '2021-10-20 14:00:00', '2021-10-20 18:00:00', 1, 2, 1),
       (1, 3, '2021-10-23 16:00:00', '2021-10-23 18:00:00', 2, 1, 2),
       (1, 2, '2021-10-19 04:00:00', '2021-10-19 18:00:00', 3, 2, 1),
       (2, 1, '2021-10-22 14:00:00', '2021-10-22 18:00:00', 1, 3, 1),
       (3, 1, '2021-10-21 14:00:00', '2021-10-21 18:00:00', 2, 1, 2),
       (3, 2, '2021-10-20 09:00:00', '2021-10-20 12:00:00', 3, 2, 3),
       (2, 3, '2021-10-19 19:00:00', '2021-10-19 22:00:00', 1, 3, 1),
       (1, 2, '2021-10-23 23:30:00', '2021-10-24 02:20:00', 2, 1, 3),
       (3, 2, '2021-10-23 11:00:00', '2021-10-23 15:00:00', 3, 3, 1),
       (2, 1, '2021-10-22 23:00:00', '2021-10-23 04:00:00', 1, 2, 2);

-- 3) Вывести самый продолжительный по времени рейс.
select * from flight where end_time - start_time = (select max(end_time - start_time) from flight);

-- 4) Вывести количество рейсов для каждого аэропорта за указанный день (одним запросом).
select a.town, count(a.town)from airport a join flight f on a.id = f.from_airport_id or a.id = f.to_airport_id
where (a.id = f.from_airport_id and start_time >= '2021-10-23 00:00:00' and start_time <= '2021-10-23 23:59:59') or
      (a.id = f.to_airport_id and end_time >= '2021-10-23 00:00:00' and end_time <= '2021-10-23 23:59:59')
group by a.town;

-- 5) Вывести ФИО пассажира, который провел в полетах наибольшее количество часов и наименьшее.
with ToF as
    (select passenger_id, first_name, last_name, sum(end_time - start_time) as time_of_flight
    from flight f right join passenger p
        on f.passenger_id = p.id group by passenger_id, first_name, last_name)

select * from ToF
where time_of_flight = (select max(time_of_flight) from ToF) or
      time_of_flight = (select min(time_of_flight) from ToF);
