CREATE TABLE managers
(
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    name    TEXT    NOT NULL,
    login   TEXT    NOT NULL UNIQUE,
    salary  INTEGER NOT NULL CHECK ( salary > 0 ),
    plan    INTEGER NOT NULL CHECK ( plan >= 0 ),
    boss_id INTEGER REFERENCES managers,
    unit Text
);

CREATE TABLE products
(
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    name  TEXT    NOT NULL UNIQUE,
    price INTEGER NOT NULL CHECK ( price > 0 ),
    qty INTEGER NOT NULL CHECK ( qty > 0 )
);

CREATE TABLE sales (
                       id INTEGER PRIMARY KEY AUTOINCREMENT,
                       manager_id INTEGER NOT NULL REFERENCES managers,
                       product_id INTEGER NOT NULL REFERENCES products,
                       qty INTEGER NOT NULL CHECK ( qty > 0 ),
                       price INTEGER NOT NULL CHECK ( price > 0 )
);