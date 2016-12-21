CREATE TABLE cats (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (id, address)
VALUES
  (1, "10 Wayne Ct"), (2, "123 W 78th");

INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, "Jon", "Slaw", 1),
  (2, "Bruce", "Slaw", 1),
  (3, "Mick", "Slaw", 2),
  (4, "Bro", "Chacho", NULL);

INSERT INTO
  cats (id, name, owner_id)
VALUES
  (1, "Peanut", 1),
  (2, "Pickle", 2),
  (3, "Percy", 3),
  (4, "Peter", 3),
  (5, "Patrick", NULL);
