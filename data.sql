-- TODO:
--  1. для каждой продажи вывести: id, сумму, имя менеджера, название товара
--  2. сосчитать, сколько (количество) продаж сделал каждый менеджер
--  3. сосчитать, на сколько (общая сумма) продал каждый менеджер
--  4. сосчитать, на сколько (общая сумма) продано каждого товара
--  5. найти топ-3 самых успешных менеджеров по общей сумме продаж
--  6. найти топ-3 самых продаваемых товаров (по количеству)
--  7. найти топ-3 самых продаваемых товаров (по сумме)
--  8. найти % на сколько каждый менеджер выполнил план по продажам
--  9. найти % на сколько выполнен план продаж по подразделениям

---1
select s.id,
       (s.qty * s.price) Sum,
       (
           select m.name
           from managers m
           where m.id = s.manager_id
       )                 Manager,
       (
           select p.name
           from products p
           where p.id = s.product_id
       )                 Product
from sales s;

---2
select count(s.manager_id) count,
       (
           select m.name
           from managers m
           where m.id = s.manager_id
       )                   manager
from sales s
group by s.manager_id;

---3
select sum(s.qty * s.price) sum,
       (
           select m.name
           from managers m
           where m.id = s.manager_id
       )                    manager
from sales s
group by s.manager_id;

---4
select sum(s.qty * s.price) sum,
       (
           select p.name
           from products p
           where p.id = s.product_id
       )                    Product
from sales s
group by s.product_id;

---5
select sum(s.qty * s.price) sum,
       (
           select m.name
           from managers m
           where m.id = s.manager_id
       )                    Manager
from sales s
group by s.manager_id
order by sum desc
limit 3;

---6
select count(s.product_id) count,
       (
           select p.name
           from products p
           where p.id == s.product_id
       )                   Product
from sales s
group by s.product_id
order by count desc
limit 3;

---7
select sum(s.qty * s.price) sum,
       (
           select p.name
           from products p
           where p.id = s.product_id
       )                    Product
from sales s
group by s.product_id
order by sum desc
limit 3;

---8
select (
           select sum((s.qty * s.price * 100.0) / m.plan) percent from managers m where m.id = s.manager_id
       ) percent,

       (
           select m.name
           from managers m
           where m.id = s.manager_id
       ) Manager
from sales s
group by s.manager_id;

--9
SELECT m2.unit,
       ifnull((
                  SELECT ss.total
                  FROM (
                           SELECT sum(s.qty * s.price)                                      total,
                                  (SELECT m.unit FROM managers m WHERE m.id = s.manager_id) unit
                           FROM sales s
                           WHERE unit = m2.unit) ss
              )
                  * 100.0 /
              (
                  SELECT sum(m1.plan)
                  FROM managers m1
                  WHERE m1.unit = m2.unit
              ), 0) Percent
FROM managers m2
group by m2.unit;

INSERT INTO managers (id, name, login, salary, plan, boss_id, unit)
VALUES (1, 'Vasya', 'vasya', 100000, 0, NULL, null), -- Ctrl + D
       (2, 'Petya', 'petya', 90000, 90000, 1, 'boy'),
       (3, 'Vanya', 'vanya', 80000, 80000, 2, 'boy'),
       (4, 'Masha', 'masha', 80000, 80000, 1, 'girl'),
       (5, 'Dasha', 'dasha', 60000, 60000, 4, 'girl'),
       (6, 'Sasha', 'sasha', 40000, 40000, 5, 'girl');

INSERT INTO products(name, price, qty)
VALUES ('Big Mac', 200, 10),       -- 1
       ('Chicken Mac', 150, 15),   -- 2
       ('Cheese Burger', 100, 20), -- 3
       ('Tea', 50, 10),            -- 4
       ('Coffee', 80, 10),         -- 5
       ('Cola', 100, 20);

INSERT INTO sales(manager_id, product_id, price, qty)
VALUES (1, 1, 150, 10), -- Vasya big mac со скидкой
       (2, 2, 150, 5),  -- Petya Chicken Mac без скидки
       (3, 3, 100, 5),  -- Vanya Cheese Burger без скидки
       (4, 1, 250, 5),  -- Masha Big Mac с наценкой
       (4, 4, 100, 5),  -- Masha Tea тоже с наценкой
       (5, 5, 100, 5),  -- Dasha Coffee c наценкой
       (5, 6, 120, 10);