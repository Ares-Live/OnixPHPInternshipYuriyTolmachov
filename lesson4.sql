/*
```console
postgres -V
psql

```

```psql
create database market;
create user intern with encrypted password 'psql123';
grant all privileges on database market to intern;
\c market intern

```
 */


CREATE TABLE IF NOT EXISTS users (
    id      SERIAL PRIMARY KEY,
    name    VARCHAR(15) NOT NULL,
    balance MONEY NOT NULL DEFAULT 0
);


CREATE TABLE IF NOT EXISTS products (
    id      SERIAL PRIMARY KEY,
    name    VARCHAR(50) NOT NULL,
    price   MONEY NOT NULL CONSTRAINT price_should_be_positive CHECK (price::numeric >= 0) DEFAULT 0,
    owner   INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE
);


INSERT INTO
    users
VALUES
    (1, 'Ares',         100 ),
    (2, 'Test User 1',  200 ),
    (3, 'Test User 2',  500 ),
    (4, 'Test User 3',  1100)
ON CONFLICT (id) DO
UPDATE SET name = EXCLUDED.name, balance = EXCLUDED.balance;


INSERT INTO
    products (name, price, owner)
VALUES
    ('PS5',     500, 1),
    ('XBOX360', 150, 2),
    ('PS4',     320, 2),
    ('PS4',     330, 3)
;


SELECT
   users.name AS user_name,
   products.name AS product_name
FROM
   users
   LEFT JOIN
      products
      ON users.id = products.owner;


UPDATE products SET owner = 1 WHERE id = '3';


DELETE FROM users WHERE id = '4';


SELECT
   users.name AS user_name,
   COUNT(products.owner) AS "Count of products"
FROM
   users
   LEFT JOIN
      products
      ON users.id = products.owner
GROUP BY users.id
ORDER BY users.id ASC;


ALTER TABLE users ADD COLUMN email varchar(50) UNIQUE;


CREATE SEQUENCE user_id_sequence START WITH 10000;
ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('user_id_sequence');


ALTER TABLE users ADD COLUMN birthdate DATE CHECK (birthdate < current_date);


ALTER TABLE users ADD COLUMN age integer;


CREATE FUNCTION set_age() RETURNS trigger AS $set_age$
    BEGIN

        IF NEW.birthdate IS NULL THEN
            NEW.age:= NULL;
            RETURN NEW;
        END IF;

        NEW.age:= EXTRACT(year FROM age(current_date, NEW.birthdate));

        RETURN NEW;
    END;
$set_age$ LANGUAGE plpgsql;


CREATE TRIGGER set_age BEFORE INSERT OR UPDATE ON users
    FOR EACH ROW EXECUTE PROCEDURE set_age();


begin;

    INSERT INTO
        users (name, balance, email, birthdate)
    VALUES ('Yuriy', 2000, 'testuser@test.com', '1997-10-23');


    INSERT INTO
        products(name, price, owner)
    VALUES
        ('iPhone XS', 700, currval('user_id_sequence')),
        ('MacBook PRO', 1350, currval('user_id_sequence'))
    ;

commit;


/* transaction will fail */
begin;

    INSERT INTO
        users (name, balance, email, birthdate)
    VALUES ('Yuriy2', 2000, 'testuser2@test.com', '1997-10-23');


    INSERT INTO
        products(name, price, owner)
    VALUES
        ('iPhone XS', 700, NULL),
        ('MacBook PRO', 1350, currval('user_id_sequence'))
    ;

commit;


/*
Dump database:
```console
pg_dump market -O -x > market.sql
```

Restore database:

```console
psql -U postgres market < market.sql
```

---
**NOTE**
if "market" is not created:
```console
psql

```
```psql
create database market;

```
---
*/