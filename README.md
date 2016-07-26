# Apalachin

A [websockets](http://tools.ietf.org/html/rfc6455) team chat built with [Erlang's](http://www.erlang.org/) [ChicagoBoss](http://www.chicagoboss.org/), using [Cowboy](https://github.com/extend/cowboy) server and [PostgreSQL](http://www.postgresql.org/).

#### Goal of the project

- Have a working example of many features of ChicagoBoss, including websockets, for the beginner.
- Be as easy to mantain as possible.
- Be stupidly fast.
- Have a working version using Elixir also.


#### Look & feel

<img alt="Apalachin look and feel" src="https://raw.github.com/joaomilho/apalachin/master/priv/static/img/shot.png" />

#### Install

1. Install [Erlang](https://www.erlang-solutions.com/downloads/download-erlang-otp) (version R15B03 +).
	You can also use ```brew install erlang``` if you're on MacOS.

2. Download and install ChicagoBoss:
	```shell
	wget wget https://github.com/ChicagoBoss/ChicagoBoss/archive/v0.8.19.tar.gz
	tar -xvf v0.8.19.tar.gz
	cd ChicagoBoss-0.8.19
	make
	```

3. Clone Apalachin:
	```shell
	git clone git@github.com:joaomilho/apalachin.git
	cd apalachin
	```

4. Copy boss.config.example to boss.config, then edit the file changing the path of ChicagoBoss and your database setup:
	```shell
	cp boss.config.example boss.config
	vi boss.config
	```

5. Run in dev mode:
	```shell
	./init-dev.sh
	```

6. Migrate (run inside project's erlang console) and generate some users:
	```shell
	> boss_migrate:run(chat).
	> User = person:new(id, "Al Capone", "al@capone.com", "1234").
        > User:save().
	> User = person:new(id, "Joe Barber", "joe@barber.com", "1234").
        > User:save().
	```

7. Open your [modern] browser on [http://localhost:8001](http://localhost:8001), sign in, and have fun!


#### Roadmap
- Add support to reference users, with @ and maybe notify 'em by email;
- Add websockets compat layer to work in IE as well;
- <del>Add tests!;</del>
- Add [bcrypt](https://github.com/mrinalwadhwa/erlang-bcrypt) to password validation;
- <del>Figure out how to have proper [migrations](https://groups.google.com/forum/#!searchin/chicagoboss/migrate/chicagoboss/Cp2e_8ZumoA/HSDzrAxrYfAJ), docs aren't helpful!;</del>
- Make setup process more user friendly;
- <del>Use [markdown](https://github.com/hypernumbers/erlmarkdown) or something like that, and allow auto urls in the chat;</del>
- <del>Save messages in the database and allow [full text search](http://www.postgresql.org/docs/8.3/static/textsearch.html);</del>
- Allow image uploads, and maybe other media stuff;
- <del>Add a [favicon](http://lab.ejci.net/favico.js/)</del> with status.
- Improve design (a lot!). Some refs:
	- http://dribbble.com/shots/1126535-Chat-UI/attachments/143882
	- http://dribbble.com/shots/506086-Google-Chat-for-Mac/attachments/34708
	- http://dribbble.com/shots/349379-Skype-chat-in-my-world?list=searches&tag=chat
