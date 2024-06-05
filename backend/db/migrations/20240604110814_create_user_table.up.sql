CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    username VARCHAR(40),
    fullname VARCHAR(40) NOT NULL,
    email VARCHAR(40) NOT NULL,
    password VARCHAR(40) NOT NULL
);