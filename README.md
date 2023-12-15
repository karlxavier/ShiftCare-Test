# ShiftCare-Test
Command-line application using Ruby.

# Commands
- To get all list of commands type `ruby search.rb -h`
- This will list all commands and its uses:
    ```
    -f, --file FILE                  Path to JSON file
    -s, --search-key KEY             Key to search on in the JSON
    -v, --search-value VALUE         Value to search for in the JSON
    -d, --search-duplicates VALUE    Search for
    -h, --help                       Show this help message

- To search use `-s` followed by the JSON key then `-v` for the value
  
  ```
  $ ruby search.rb -f clients.json -s full_name -v "John Doe"
  $ Results: 2
    [
      {
        "id": 1,
        "full_name": "John Doe",
        "email": "john.doe@gmail.com"
      },
      {
        "id": 2,
        "full_name": "John Doe",
        "email": "jane.smith@yahoo.com"
      }
    ]
  ```
- To get all duplicates use `-d` command followed by the JSON key you want to check.
 
  ```
   $ ruby search.rb -f clients.json -d full_name
   $ Results: 2
    [
      {
        "id": 1,
        "full_name": "John Doe",
        "email": "john.doe@gmail.com"
      },
      {
        "id": 2,
        "full_name": "John Doe",
        "email": "jane.smith@yahoo.com"
      }
    ]
  ```
