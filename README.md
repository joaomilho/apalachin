# Apalachin
===

A [websockets](http://tools.ietf.org/html/rfc6455) team chat built with [Erlang's](http://www.erlang.org/) [ChicagoBoss](http://www.chicagoboss.org/), using [Cowboy](https://github.com/extend/cowboy) server and [PostgreSQL](http://www.postgresql.org/).

#### Goal of the project

- Have a working example of many features of ChicagoBoss, including websockets, for the begginer.
- Be as easy to mantain as possible.
- Be stupidly fast.
- Have a working version using Elixir also.

#### Install

1. Install [Erlang](https://www.erlang-solutions.com/downloads/download-erlang-otp) (version R15B03 +).
	You can also use ```brew install erlang``` if you're on MacOS.

2. Download and install ChicagoBoss:
	```shell
	wget http://www.chicagoboss.org/ChicagoBoss-0.8.7.tar.gz
	tar -xvf ChicagoBoss-0.8.7.tar.gz
	cd ChicagoBoss
	make
	```

3. Clone Apalachin:
	```shell
	git clone git@github.com:joaomilho/apalachin.git
	cd apalachin
	./init-dev.sh
	```
	
4. Copy boss.config.example to boss.config, then edit the file changing the path of ChicagoBoss and your database setup:
	```shell
	cp boss.config.exemple boss.config
	vi boss.config
	```

5. Run in dev mode:
	```shell
	./init-dev.sh
	```

6. Migrate (run inside project's erlang console):
	```shell
	> boss_migrate:run(chat).
	```

7. Open Safari or Firefox on http://localhost:8001, sign in, and have fun!

#### Roadmap
- Add websockets compat layer to work in Chrome/IE as well;
- Add tests!;
- Add [bcrypt](https://github.com/mrinalwadhwa/erlang-bcrypt) to password validation;	
- Figure out how to have proper [migrations](https://groups.google.com/forum/#!searchin/chicagoboss/migrate/chicagoboss/Cp2e_8ZumoA/HSDzrAxrYfAJ), docs aren't helpful!;
- Make setup process more user friendly;
- Use [markdown](https://github.com/hypernumbers/erlmarkdown) or something like that, and allow auto urls in the chat;
- Save messages in the database and allow [full text search](http://www.postgresql.org/docs/8.3/static/textsearch.html);
- Allow image uploads, and maybe other media stuff;
- Add a [favicon](http://lab.ejci.net/favico.js/) with status.
- Improve design (a lot!). Some refs:
	- http://dribbble.com/shots/1126535-Chat-UI/attachments/143882
	- http://dribbble.com/shots/506086-Google-Chat-for-Mac/attachments/34708
	- http://dribbble.com/shots/349379-Skype-chat-in-my-world?list=searches&tag=chat