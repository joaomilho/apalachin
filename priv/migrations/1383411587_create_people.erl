%% Migration: create_people

UpSQL = "
  CREATE TABLE people(
    id serial unique,
    name text not null,
    email text not null,
    password text not null
  );
".

DownSQL = "DROP TABLE people;".

{create_people,
  fun(up)   -> boss_db:execute(UpSQL);
     (down) -> boss_db:execute(DownSQL)
  end}.
