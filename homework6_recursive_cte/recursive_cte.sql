create table recursive_table
(
    id serial primary key,
    start_point varchar(5),
    end_point varchar(5),
    length integer
);

insert into recursive_table(start_point, end_point, length)
values ('V', 'Y', 2),
       ('S', 'X', 5),
       ('S', 'U', 3),
       ('Y', 'V', 7),
       ('Y', 'S', 3),
       ('U', 'V', 6),
       ('U', 'X', 2),
       ('X', 'V', 4),
       ('X', 'Y', 6),
       ('X', 'U', 1);

--Все пути из вершины S в Y
with recursive recursive_cte (end_point2, points, distance, way) as
    (select distinct start_point, 1, 0, 'S'
    from recursive_table
    where start_point = 'S'
    union all
    select end_point,
           rec_cte.points + 1,
           rec_cte.distance + rec_table.length,
           rec_cte.way || ', ' || rec_table.end_point
    from recursive_table as rec_table
        inner join recursive_cte as rec_cte on rec_cte.end_point2 = rec_table.start_point
    where rec_cte.way not like '%' || rec_table.end_point || '%')
select * from recursive_cte where end_point2 = 'Y';

--Кратчайший путь и его стоимость
with recursive recursive_cte (end_point2, points, distance, way) as
   (select distinct start_point, 1, 0, 'S'
    from recursive_table
    where start_point = 'S'
    union all
    select end_point,
           rec_cte.points + 1,
           rec_cte.distance + rec_table.length,
           rec_cte.way || ', ' || rec_table.end_point
    from recursive_table as rec_table
             inner join recursive_cte as rec_cte on rec_cte.end_point2 = rec_table.start_point
    where rec_cte.way not like '%' || rec_table.end_point || '%'),
    short_distanse(distance) as
        (select min(distance)
        from recursive_cte
        where end_point2 = 'Y'),
    short_points(points) as
        (select min(points)
         from recursive_cte
         where end_point2 = 'Y')
select r.end_point2, r.points, r.distance, r.way from recursive_cte r
    inner join short_distanse sd on r.distance = sd.distance
    inner join short_points ss on r.points = ss.points;
