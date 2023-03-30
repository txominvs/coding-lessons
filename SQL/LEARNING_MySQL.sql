-- Charset is given by [^a-zA-Z0-9\(\)\,\"\'\n\t\;\&\-\ \<\>\.\*\+\\\=\/\_\[\]\:\?\@\!\%\{\}\$\^]
-- LEARNIGN MySQL https://dev.mysql.com/doc/refman/8.0/en/tutorial.html

sudo mysql [ -h host_address -u user_name -p database_name ]
sudo mysql -t < script_file > output file -- the T flag is for "pretty output"
QUIT -- equivalent to CTR+D or CTR+C to end current input


SELECT VERSION(), CURRENT_DATE;
SELECT SIN(PI()/4), (4+1)*3, NOW(), USER();
GRANT ALL ON name_of_private_sql_database.* TO 'your_mysql_name'@'your_client_host';


SHOW DATABASES;
USE databasename
CREATE DATABASE menagerie;
SELECT DATABASE(); -- view current DB


SHOW TABLES;
DESCRIBE table_name; -- equivalently DESC table_name, "KEY" represents INDEXING of the column, that is, a "hash map"
CREATE TABLE pet_table (its_name VARCHAR(20), sex CHAR(1), birth DATE); -- SHOW CREATE TABLE existing_table to view how to clone an existing table structure
CREATE TABLE shop (
    article INT UNSIGNED  DEFAULT '0000' NOT NULL,
    dealer  CHAR(20)      DEFAULT ''     NOT NULL,
    price   DECIMAL(16,2) DEFAULT '0.00' NOT NULL,
    PRIMARY KEY(article, dealer));


LOAD DATA LOCAL INFILE '/path/pets.txt' INTO TABLE table_name; -- Linux, but for windows add LINES TERMINATED BY '\r\n'; and use '\r' for macOS
-- If security does not allow LOADING: A) SET GLOBAL local_infile=1; B) quit C) sudo mysql --local-infile=1 -u root -p1
-- Default parameters: LOAD DATA [...] FIELDS TERMINATED BY '\t' ENCLOSED BY '' ESCAPED BY '\\' LINES TERMINATED BY '\n' STARTING BY '';
/* == pets.txt == columns are separated by tabs and NULL is written \N
example_pet	M	2019-04-02
some_other	F	1998-01-20
another_one	M	\N
last_one	\N	2022-12-22
*/


ALTER TABLE old_table_name RENAME new_table_name;
ALTER TABLE table_name RENAME COLUMN old_name TO new_name;
ALTER TABLE table_name MODIFY column_name BIGINT UNSIGNED DEFAULT 1;
ALTER TABLE table_name CHANGE old_column_name new_column_name INT UNSIGNED NOT NULL;
ALTER TABLE table_name ADD new_column TIMESTAMP;
ALTER TABLE table_name DROP COLUMN column_name;
ALTER TABLE table_name ADD INDEX;
ALTER TABLE table_name DROP PRIMARY KEY, ADD PRIMARY KEY(column_name);
ALTER TABLE table_name ADD something INT, DROP another_col, RENAME COLUMN old TO new; -- operations can be chained!


INSERT INTO table_name VALUES ('doggo_name', NULL, '2022-04-21'), ('anotherone', 'F', '1997-12-1'), ('catname', 'M', '2003-2-2');
INSERT INTO table_name (its_name, sex, birth) VALUES('kk', 'M', '1990-1-3'), ('test', 'F', '1995-1-3'); -- explicitly stating column order
INSERT INTO table_name SELECT * FROM another_table;


DELETE FROM table_name; -- empty the whole table, it can be used with WHERE to delete speficic rows. See also TRUNCATE TABLE table_name
DROP TABLE shop; -- destroy the table


UPDATE table_name SET birthday = '1993-1-14' WHERE its_name = 'Timmy';


SELECT * FROM table_name; -- asterisk means all columns
SELECT name, birthday FROM table_name WHERE name = 'tommy' OR (sex = 'F' AND name = 'alex'); -- equality is case insensitive
					WHERE name <> 'tommy' -- different, also != operator
					WHERE name IS NOT NULL -- special handling for null
					WHERE age < 5 -- less than and so on
-- https://dev.mysql.com/doc/refman/8.0/en/comparison-operators.html


SELECT DISTINCT name FROM table_name; -- output rows will all be different (grouping)
SELECT name, sex FROM table_name ORDER BY name; ORDER BY name ASC; -- small to big, use ORDER BY BINARY for case-sensitive
SELECT its_name, sex FROM table_name ORDER BY its_name, sex DESC; -- descending order Z-A but just for the SEX, the its_name ordering is unaffected by DESC


SELECT name, CURDATE(),
	TIMESTAMPDIFF( YEAR, birthday, CURDATE() ) AS age, birthday -- alias column AGE and DATE manipulations
	FROM pet_table ORDER BY age DESC, name; -- alias columns can be used like actual columns
SELECT birth, MONTH(birth), YEAR(birth), DAYOFMONTH(birth) as day FROM pet_table;
SELECT its_name, birth FROM pet_table
	WHERE MONTH(birth) = MONTH(
		DATE_ADD(CURDATE(), INTERVAL 5 MONTH)
	);
-- or equivalently
	WHERE MONTH(birth) = MOD( MONTH(CURDATE()) , 12) + 1
SELECT '2018-10-31' + INTERVAL 5 DAY; -- equivalently to SELECT DATE_ADD( CAST('2018-10-31' AS DATE), INTERVAL 5 DAY);
SHOW WARNINGS; -- in case an invalid date is used SELECT CAST('2018-10-32' AS DATE);


SELECT 'hi!' IS NOT NULL, '' IS NOT NULL, 0 IS NOT NULL, (NULL = 7) IS NULL, (NULL + 7) IS NULL, (NULL > 9) IS NULL; -- when using ORDER BY null  values go first, and ORDER BY ... DESC go in the last place


SELECT 'hello' LIKE 'h_llo', 'test' LIKE '%e__'; -- PATTERNS: underscore matches 1 character and percent matches 0 or more charcaters, comparisons are case-insensitive
SELECT * FROM pet_table WHERE its_name LIKE 'b%' AND its_name NOT LIKE '%y';

SELECT * FROM pet_table WHERE REGEXP_LIKE(name, '^.[abc]{5}[0-9]*$'); -- REGULAR EXPRESIONS case insensitive, also the REGEXP or RLIKE operators
REGEXP_LIKE(name, '^b' COLLATE utf8mb4_0900_as_cs); REGEXP_LIKE(name, BINARY '^b'); REGEXP_LIKE(name, '^b', 'c'); -- for case SENSITIVE


SELECT COUNT(*) FROM table_name;
SELECT its_name, sex, COUNT(*)
	FROM table_name
	WHERE sex IS NOT NULL AND its_name <> 'timmy'
	GROUP BY its_name, sex
/*ERROR if SET sql_mode = 'ONLY_FULL_GROUP_BY'; disable by SET sql_mode = ''*/ SELECT its_name, sex, COUNT(*) FROM table_name; -- no grouping is carried out (all rows are COLLATED as equal, too broad grouping), and then a RANDOM REPRESENTATIVE of these rows is chosen for the output
SELECT name, sex, COUNT(*) GROUP BY name, sex; -- perfect
SELECT name, sex, COUNT(*) GROUP BY name; -- error, RANDOM REPRESENTATIVE must to be chosen for sex...
SELECT COUNT(*) GROUP BY name, sex; -- ok, it does work, but how do we know what each COUNT belongs to?


SELECT sex FROM pet_table WHERE sex IS NOT NULL GROUP BY sex HAVING COUNT(its_name) > 2; -- Order of execution: WHERE > GROUP BY > SELECT > HAVING. First NULL sexes are discarded; then rows are GROUPPED BY sex; and finally only groups HAVING more than 2 rows are shown. Since WHERE is executed before GROUP BY and SELECT it *cannot* use aggregate functions nor aliases, whereas HAVING can.
SELECT mins*60 AS secs FROM time_table WHERE secs > 55; -- ERROR! WHERE cannot use aliases


-- AGGREGATE FUNCTIONS: the GROUP BY clause creates various subtables and AGGREGATE FUNCTIONS swallow these sub-tables and turn them into a single row. Examples of AGGREGATE FUNCTIONs include AVG(), SUM(), MAX(), MIN(), COUNT() and BIT_OR().
SELECT year, month, COUNT(DISTINCT day) AS days FROM vists_table GROUP BY year, month; -- each subtable has days within the same year/month. Count the number of days where somebody made a visit in each subtable <=> distinct days when someone showed up
SELECT year, month, BIT_COUNT(BIT_OR(1<<day)) AS days FROM vists_table GROUP BY year, month; -- the 1<<day function creates a BITMASK 1000. Applying the BIT_OR to the whole table create a BIT FLAG like 1110001101100 where 1=someone visited us this day 0=nobody showed up this day. BIT_COUNT() counts the number of 1 bits in the BIT FLAG 1110001101100 <=> how many days there was a visit

SELECT name, id FROM hotel_users WHERE name = 'richard'
	UNION
SELECT name, id FROM hotel_users WHERE id = 323;

SELECT pet.name, TIMESTAMPDIFF( YEAR, pet.birth, event.date ) AS age, remark
	FROM pet INNER JOIN event
	ON pet.name = event.name
	WHERE event.type = 'litter';

SELECT pet1.name, pet2.name, pet1.species AS species
	FROM pet AS pet1 INNER JOIN pet AS pet2
	ON pet1.species = pet2.species
		AND pet1.name > pet2.name; -- avoid repeated pairs (Billy, Anna) = (Anna, Billy)


SELECT MAX(colum_name) FROM table_name;
SELECT * FROM shop WHERE price = (SELECT MAX(price) FROM shop);
SELECT * FROM shop ORDER BY price DESC LIMIT 1;
SELECT s1.*, s2.* FROM shop AS s1 LEFT JOIN shop AS s2 ON s1.price < s2.price -- join each article(s1) with every article(s2) that is more expensive
	WHERE s2.article IS NULL; -- select the articles(s1) that do not have any article(s2) more expensive than them

SELECT article, MAX(price) FROM shop GROUP BY article;
SELECT * FROM shop AS s1 WHERE s1.price = (SELECT MAX(s2.price) FROM shop AS s2 WHERE s2.article = s1.article); -- correlated subquery, inefficient
SELECT s1.* FROM shop AS s1 LEFT JOIN shop AS s2 ON ( s1.article=s2.article AND s1.price < s2.price ) WHERE s2.article IS NULL; -- join each article with all more expensive same-type articles, and select articles for which no more expensive articles are found <=> the most expensive ones
SELECT s1.* FROM shop AS s1
	INNER JOIN -- also plain JOIN short for INNER JOIN
(SELECT article, MAX(price) as max_price FROM shop GROUP BY article) AS s2 -- table contains max price per article
	ON
s1.article = s2.article AND s1.price = s2.max_price; -- only if row present in both the table s1 and the "most expensive per article" list s2


SELECT *, RANK() OVER (ORDER BY price) FROM shop; -- enumerate articles per price (lowest to highest)
SELECT *, RANK() OVER (PARTITION BY article ORDER BY price) FROM shop; -- make group per article-type, then inside each group enumerate by price
SELECT s1.*, COUNT(s2.article)+1 AS rank_id FROM shop AS s1 -- count how many cheaper articles of the same type there are <=> rank (lowest to highest)
LEFT JOIN shop AS s2 ON s1.price>s2.price AND s1.article=s2.article -- join every article (s1) with each cheaper article of the same type (s2)
GROUP BY s1.article, s1.price, s1.dealer; -- make groups with same articles (s1) so we can count how many cheaper articles (s2) it has been joined to


WITH temp_stock_per_article AS (SELECT article, COUNT(*) AS stock FROM shop GROUP BY article)
SELECT * FROM temp_stock_per_article WHERE article = '1'; -- instead, just write SELECT article, COUNT(*) AS stock FROM shop WHERE article = '1';


SELECT @most_expensive := MAX(price) FROM shop; SELECT * FROM shop WHERE price = @most_expensive; -- user defined VARIABLES (for multiple queries)
SELECT pet.*, @counter_index := @counter_index+1 AS counter -- equivalent to SELECT *, RANK() OVER (ORDER BY name) FROM pet;
	FROM pet, (SELECT @counter_index := 0) AS _unused -- slick initialization for counter variable
	ORDER BY name;


PREPARE statement FROM 'SELECT * FROM shop WHERE dealer = ?'; SET @dealer_name = 'A'; EXECUTE statement USING @dealer_name; DEALLOCATE PREPARE statement; -- Alternatively, see also CALL procedures/functions


CREATE TABLE person (
    first_name VARCHAR(50) NOT NULL,
	PRIMARY KEY (first_name), -- primary key: unique index and NOT NULL, one allowed per table

	last_name VARCHAR(50),
	UNIQUE name_given_to_index (last_name), -- unique index: no repeated values

    city VARCHAR(50),
    INDEX another_index (city) -- also KEY: indexes are used for quick lookups
);

CREATE TABLE hotel_users (
	name VARCHAR(20) NOT NULL,
	id INT UNSIGNED NOT NULL,
	PRIMARY KEY (id)
) ENGINE=INNODB; -- InnoDB is the only one that supports FOREIGN KEYS
CREATE TABLE booked_rooms (
	room_number INT,
	tenant_id INT,
	INDEX index_name (tenant_id), -- MySQL requires that foreign key columns be indexed, otherwise an index is automatically created
	FOREIGN KEY (tenant_id) REFERENCES hotel_users(id) -- foreign keys must reference PRIMARY or UNIQUE KEYs in another table
		ON UPDATE RESTRICT -- default, optional: cannot ADD to CHILD, without reference in PARENT
		ON DELETE RESTRICT -- default, optional: cannot REMOVE from PARENT, if there are still references in CHILD
) ENGINE=INNODB; -- InnoDB is the only one that supports FOREIGN KEYS

		ON UPDATE CASCADE -- when CHANGING the tenant_id from PARENT, its ID in CHILD will be updated as well
		ON DELETE CASCADE -- when REMOVING from PARENT, delete all references in CHILD

INSERT INTO booked_rooms (room_number,tenant_id) VALUES (43, 2); -- ERROR, no user with ID=1
INSERT INTO hotel_users (id, name) VALUES (1,'Richard'); -- new user
INSERT INTO booked_rooms (room_number,tenant_id) VALUES (41, 1); -- new user books a room
DELETE FROM hotel_users WHERE id = 1; -- ERROR, cannot delete user if it has booked a room


CREATE TABLE hotel_users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT, -- automatically sets an (increasing) ID number to each entry
	name VARCHAR(20) NOT NULL,
	PRIMARY KEY (id)
) ENGINE=INNODB; -- InnoDB is the only one that supports FOREIGN KEYS
ALTER TABLE hotel_users AUTO_INCREMENT = 100; -- set starting point for ID auto_increment
INSERT INTO hotel_users VALUES (200, 'Richy'); -- another way of setting the starting point for ID auto_increment
INSERT INTO hotel_users VALUES (NULL, 'Mike'); -- automatically decide ID
INSERT INTO hotel_users (name) VALUES ('Robert'), ('Lara'), ('Gizzele'); -- another way of automatically deciding the ID number


-- DDL - Data Definition Language
	CREATE, DROP, ALTER, TRUNCATE
-- DQL - Data Query Language
	SELECT
-- DCL - Data Control Language
	GRANT, REVOKE
-- DML - Data Manipulation Language
	INSERT, UPDATE, DELETE
	LOCK TABLE table_name WRITE; -- other sessions cannot read/write table
	UNLOCK TABLES; -- other sessions will be "frozen" until lock is undone
-- TCL - Transaction Control Language
	SET autocommit = ON;
	START TRANSACTION; -- BEGIN (WORK);
	INSERT INTO hotel_users (id, name) VALUES (NULL, 'Crappy');
	SAVEPOINT savepoint_name;
	INSERT INTO hotel_users (id, name) VALUES (NULL, 'Carly');
	RELEASE SAVEPOINT savepoint_name; -- free memory from the savepoint "savepoint_name"
	ROLLBACK TO savepoint_name; -- discard changes after "savepoint_name"
	COMMIT; -- permanently save changes & release all savepoints
	ROLLBACK; -- discard ALL changes & release all savepoints

