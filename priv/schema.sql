CREATE TABLE people(
  id serial unique,
  name text not null,
  email text not null,
  password text not null
);

CREATE TABLE messages(
  id serial unique,
  person_id integer  not null references people(id),
  message text not null,
  created_at timestamp not null
);

