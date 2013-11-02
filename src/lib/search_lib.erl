-module(search_lib).
-compile(export_all).

search(Query) ->
  SearchSQL = "
    SELECT
      messages.id,
      people.name,
      people.email,
      messages.created_at,
      ts_headline(message, plainto_tsquery($1)) as message
    FROM
      messages JOIN people ON(messages.person_id = people.id),
      plainto_tsquery($1) query
    WHERE query @@ to_tsvector(message)
    ORDER BY ts_rank_cd(to_tsvector(message), query) DESC
    LIMIT 10;",

  {ok, _, Columns} = boss_db:execute(SearchSQL, [Query]),
  Columns.
