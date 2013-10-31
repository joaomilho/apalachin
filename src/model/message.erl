-module(message, [Id, PersonId, Message, CreatedAt]).
-compile(export_all).

-belongs_to(person).
