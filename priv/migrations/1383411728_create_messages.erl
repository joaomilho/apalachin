%% Migration: create_messages

UpSQL = "
  CREATE TABLE messages(
    id serial unique,
    person_id integer  not null references people(id),
    message text not null,
    created_at timestamp not null
  );

  CREATE INDEX search_idx
    ON messages
    USING gin(to_tsvector('english', message));
".

DownSQL = "DROP TABLE messages;".

{create_messages,
  fun(up)   -> boss_db:execute(UpSQL);
     (down) -> boss_db:execute(DownSQL)
  end}.
