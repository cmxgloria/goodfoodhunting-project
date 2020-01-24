CREATE DATABASE goodfoodhunting;

CREATE TABLE dishes (
  id SERIAL PRIMARY KEY,
  name VARCHAR(200),
  image_url VARCHAR(500)
  -- user_id INTEGER not null,
  -- FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;

);
-- if before create table have not null, no need to at bottom, or do at bottom

INSERT INTO dishes (name, image_url)
VALUES ('cake' ,'https://external-preview.redd.it/c_vzWtLiA68nNfS1p8Q3AD_396nL39uDIwoj9DDjnC8.jpg?auto=webp&s=a2ef37b6acbe9d2fc0bc8ca737040558f4f6e6a2');

INSERT INTO dishes (name, image_url)
VALUES ('ribs' ,'https://images.anovaculinary.com/sous-vide-barbecue-ribs/finishing-steps/sous-vide-barbecue-ribs-finishing-steps-image-2.jpg');

--  delete old one and copy and create new one, only single quote inside sql ' '  and with ; at the end


CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(300),
  password_digest VARCHAR(400)
);

ALTER TABLE dishes ADD COLUMN user_id INTEGER;

ALTER TABLE users ADD CONSTRAINT unique_email UNIQUE (email);

ALTER TABLE dishes ADD CONSTRAINT user_id_fk FOREIGN KEY(user_id) REFERENCES users (id) ON DELETE CASCADE;
