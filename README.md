Dependencies:
-Rubymine
-RVM (mac or linux) => http://rvm.io/rvm/install

Install RVM (development version):
	\curl -sSL https://get.rvm.io | bash

-Ruby 2.0
Install 2.0:
	rvm install 2.0


If (mac or linux):
	rvm use 2.0
	rvm gemset create meteodino


Enter to project directory:
	bundle install --without production

	rake db:create
	rake db:migrate
	rake db:seed #load data
	rails s
