-- =========================================================================
-- SYSTEM: Football Ticket Booking System Database Setup Template
-- DESCRIPTION: Pseudo-DDL Template for Table Creation & Data Insertion
-- INSTRUCTIONS: Replace 'TYPE' and the constraint placeholders with your own
--               actual data types, relational keys, and check criteria.
-- =========================================================================

-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
CREATE TABLE Users (
    user_id TYPE,
    full_name TYPE,
    email TYPE,
    role TYPE,
    phone_number TYPE,
    
    -- Write your constraint to make 'user_id' the Primary Key
    -- Write your constraint to ensure 'email' values are never duplicated
    -- Write your check constraint to restrict 'role' to specific allowed strings
);

-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE Matches (
    match_id TYPE,
    fixture TYPE,
    tournament_category TYPE,
    base_ticket_price TYPE,
    match_status TYPE,
    
    -- Write your constraint to make 'match_id' the Primary Key
    -- Write your check constraint to prevent negative ticket prices
    -- Write your check constraint to restrict 'match_status' values
);

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE Bookings (
    booking_id TYPE,
    user_id TYPE,
    match_id TYPE,
    seat_number TYPE,
    payment_status TYPE,
    total_cost TYPE,
    
    -- Write your constraint to make 'booking_id' the Primary Key
    -- Write your Foreign Key constraint linking 'user_id' to the Users table
    -- Write your Foreign Key constraint linking 'match_id' to the Matches table
    -- Write your check constraint to ensure 'total_cost' is non-negative
    -- Write your check constraint to restrict 'payment_status' values
);


-- =========================================================================
-- CREATE USERS TABLE
-- =========================================================================
CREATE TABLE users (
    user_id serial PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL
        CHECK (role IN ('Football Fan', 'Ticket Manager')),
    phone_number VARCHAR(20)
);

-- =========================================================================
-- CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE matches (
    match_id INT PRIMARY KEY,
    fixture VARCHAR(255) NOT NULL,
    tournament_category VARCHAR(255) NOT NULL,
    base_ticket_price DECIMAL(10,2) NOT NULL
        CHECK (base_ticket_price >= 0),
    match_status VARCHAR(20) NOT NULL
        CHECK (
            match_status IN
            ('Available', 'Selling Fast', 'Sold Out', 'Postponed')
        )
);

-- =========================================================================
-- CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    match_id INT NOT NULL,
    seat_number VARCHAR(20),
    payment_status VARCHAR(20)
        CHECK (
            payment_status IN
            ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
        ),
    total_cost DECIMAL(10,2) NOT NULL
        CHECK (total_cost >= 0),

    CONSTRAINT fk_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id),

    CONSTRAINT fk_match
        FOREIGN KEY (match_id)
        REFERENCES matches(match_id)
);


-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);

-- =========================================================================
-- QUERY-1:
-- =========================================================================
select match_id,
       fixture,
       (base_ticket_price)
from matches
where tournament_category = 'Champions League'
  AND match_status = 'Available';

-- =========================================================================
-- QUERY-2:
-- =========================================================================
select user_id,
       full_name,
       email
from users
where full_name ILIKE 'Tanvir%'
   OR full_name ILIKE '%Haque%';

-- =========================================================================
-- QUERY-3:
-- =========================================================================
select booking_id,
       user_id,
       match_id,
       COALESCE(payment_status, 'Action Required')
       as systematic_status
from bookings
where payment_status IS NULL;

-- =========================================================================
-- QUERY-4:
-- =========================================================================
select b.booking_id,
       u.full_name,
       m.fixture,
       b.total_cost
from bookings b
inner join users u
    ON b.user_id = u.user_id
inner join matches m
    ON b.match_id = m.match_id;

-- =========================================================================
-- QUERY-5:
-- =========================================================================
select u.user_id,
       u.full_name,
       b.booking_id
from users u
left join bookings b
    ON u.user_id = b.user_id
order by u.user_id;

-- =========================================================================
-- QUERY-6:
-- =========================================================================
select booking_id,
       match_id,
       total_cost
from bookings
where total_cost >
(
    select avg(total_cost)
    from bookings
);

-- =========================================================================
-- QUERY-7:
-- =========================================================================
select match_id,
       fixture,
       base_ticket_price
from matches
order by base_ticket_price DESC limit 2 offset 1;

