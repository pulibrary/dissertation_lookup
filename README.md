# README for `dissertation_lookup`

This script demonstrates fetching an object's full metadata payload from DSpace 5.x using the full title value.

## Requirements

* Ruby 3.0.3
* List of dissertation titles in a flat text file ([example](manifest.example))

## Running the script

### Setup

1. Check out the code.
2. `bundle install`

### How to use

1. Create a manifest of dissertation titles.
  * Each title must be an exact match to the dissertation in DataSpace.
  * Each title must NOT have any trailing periods.
2. Run the script as follows: `ruby lookup.rb $MANIFEST`
  * Where `$MANIFEST` is the path to the manifest file you are using.
