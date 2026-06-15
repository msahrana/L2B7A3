-- =========================================================================
-- CREATE USERS TABLE
-- =========================================================================
CREATE TABLE Users (
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
CREATE TABLE Matches (
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
CREATE TABLE Bookings (
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
        REFERENCES Users(user_id),

    CONSTRAINT fk_match
        FOREIGN KEY (match_id)
        REFERENCES Matches(match_id)
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
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Postponed');

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00),
(506, 3, 101, 'D-22', 'Cancelled', 120.00);


-- =========================================================================
-- QUERY-1:
-- =========================================================================
select match_id,
       fixture,
       (base_ticket_price)
from Matches
where tournament_category = 'Champions League'
  AND match_status = 'Available';

-- =========================================================================
-- QUERY-2:
-- =========================================================================
select user_id,
       full_name,
       email
from Users
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
from Bookings
where payment_status IS NULL;

-- =========================================================================
-- QUERY-4:
-- =========================================================================
select b.booking_id,
       u.full_name,
       m.fixture,
       b.total_cost
from Bookings b
inner join Users u
    ON b.user_id = u.user_id
inner join Matches m
    ON b.match_id = m.match_id;

-- =========================================================================
-- QUERY-5:
-- =========================================================================
select u.user_id,
       u.full_name,
       b.booking_id
from Users u
left join Bookings b
    ON u.user_id = b.user_id
order by u.user_id;

-- =========================================================================
-- QUERY-6:
-- =========================================================================
select booking_id,
       match_id,
       total_cost
from Bookings
where total_cost >
(
    select avg(total_cost)
    from Bookings
);

-- =========================================================================
-- QUERY-7:
-- =========================================================================
select match_id,
       fixture,
       base_ticket_price
from Matches
order by base_ticket_price DESC limit 2 offset 1;
