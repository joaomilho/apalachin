-module(search_lib).
-compile(export_all).

search(Query) ->
  SearchSQL = "
    SELECT
      'message-' || messages.id::text
    FROM
      messages JOIN people ON(messages.person_id = people.id),
      plainto_tsquery($1) query
    WHERE query @@ to_tsvector(message)
    ORDER BY ts_rank_cd(to_tsvector(message), query) DESC
    LIMIT 10;",

  {ok, _, Columns} = boss_db:execute(SearchSQL, [Query]),
  Ids = lists:map(fun(Column) -> {Id} = Column, binary_to_list(Id) end, Columns),
  case Ids of
    [] -> [];
    _ -> boss_db:find(message, [{id, in, Ids}])
  end.
