This is the Football Ticket Booking System contains three main entities: Users, Matches, and Bookings. The database relationships are implemented as:

One-to-Many: One User can create many Bookings.
One-to-Many: One Match can have many Bookings.

Therefore, the ERD correctly represents the system using two one-to-many relationships:

Users (1) → Bookings (M)

Matches (1) → Bookings (M)

The Bookings table acts as a transactional bridge between Users and Matches while maintaining a logical one-to-one association for each individual reservation.
