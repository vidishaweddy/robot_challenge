## Getting Started
Create a directory to work on your project. Copy the zipped file into your project directory and extract the project files

Robot Challenge app requires ruby and bundler to be installed. Before you begin; install the dependencies by running `bundle`.
Once the dependencies have been installed you'll have a few commands available:
- `bundle exec rake`  : Will attempt to run your application and print output to the terminal.
- `bundle exec rspec` : Runs the test suite.
- `ruby -r "./lib/robot_challenge.rb" -e "RobotChallenge.call"`: Run application via ruby command


## Using Docker
System requires docker to be installed in order to build and run commands through docker. The step to run the app
1. Run docker-compose -up
2. docker exec -ti <app_name> /bin/sh
3. Run bundle exec rake to start the app
