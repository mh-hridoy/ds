CREATE TABLE album (
  id         SERIAL PRIMARY KEY,
  title      VARCHAR(128) NOT NULL,
  artist     VARCHAR(255) NOT NULL,
  price      DECIMAL(5,2) NOT NULL
);
