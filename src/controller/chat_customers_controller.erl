-module(chat_customers_controller, [Req]).
-compile(export_all).


index('GET', []) ->
  Customers = boss_db:find(customer, []),
  {ok, [{customers, Customers}]};

index('POST', []) ->
  Customer = customer:new(id, Req:post_param("pno"), Req:post_param("name")),

  case Customer:save() of
    {ok, _}          -> {redirect, "/"};
    {error, Errors}  -> {ok, [{errors, Errors}]}
  end.
