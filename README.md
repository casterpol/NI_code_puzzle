# NI_code_puzzle

### Abbrieviations:
Throughout the project, I have used "ni" instead of "National Insurance"


### The main file in this project is "ni_builder.rb"
This file is the main entry point. By calling the build_ni method, it will run through and produce an updated
csv file which includes national insurance numbers. high level country of birth figures will be output to the terminal

### There are support folders called:
#### data
* data_set.csv = (main data set)
* file_constants.rb = hardcoded headers for output csv file
* ni_constants.rb = constants relating to ni number


#### support
* file_helpers.rb = module containing methods to interact with csv files
* ni_factory.rb = module containing methods to build an ni number
* person.rb = creates "person" object

## How to run

#### Gemfile
This project uses a gem called colourize, please run the following commmand from the root file to install the gem locally:
```
bundle install
```

#### Run options
I have left 3 lines at the bottom of ni_builder.rb (2 commented out), these method calls are examples of how to run the code.
Optional_space is a flag that takes in true / false, it defaults as false if not passed in.
if you are using an ide such as rubymine, you can press play on the current file, alternatively you can run the file with the terminal command below:
```
ruby ni_builder.rb
```


#### Results folder
The results folder has been left empty, however, if you choose the option to save to csv, this is where the files will be saved
