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

## Robot Challenge App
Robot challenge app is an application that simulate robot's movement on 5x5 tabletop.
There are several actions/commands that can be done on the app. the commands are
- `PLACE <coord_x>,<coord_y>,<direction>`: A command to place the robot on top of the table top. 
Coordinates must be between of 0 and 5. 
Direction is based on compass points which are NORTH, EAST, SOUTH and WEST.
PLACE command must be added before other commands for other commands to take action.
Other commands will also be ignored if PLACE command is invalid or PLACE command causes the robot to be put outside the tabletop 
- `MOVE`: A command to move the robot one point towards the direction its currently heading
- `LEFT`: A command to turn the robot to the left of its current direction
- `RIGHT`:  A command to turn the robot to the right of its current direction
- `REPORT`: A command to close the list of actions prior to this command and return the current location and direction of the robot

NOTE: All commands must be in uppercase. Wrong or invalid commands will be ignored
