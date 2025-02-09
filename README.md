# Illusion Patterns

A Ruby command-line app which which transforms [Open Cross Stitch](https://www.ursasoftware.com/OXSFormat/) (.oxs) patterns into ["shadow knitting"](https://en.wikipedia.org/wiki/Illusion_knitting) patterns.

## Setup

This project requires Ruby 3.4.1.

```bash
$ git clone git@github.com:nahiluhmot/illusion_patterns
$ cd ./illusion_patterns/
$ bundle install
```

## Usage

To generate a shadow knitting pattern from your pattern, run:

```bash
$ ./bin/illusion_patterns path/to/your/pattern.oxs 0 29 up
```

Breakdown:

* `./bin/illusion_patterns` - the executable provided by this application
* `path/to/your/pattern.oxs` - an Open Cross Stitch file which contains your pattern
* `0` - the palette index of the background color of your pattern; this will be used for the "light" shadow knitting stripes
* `29` - the palette index of the "dark" shadow knitting stripes; this color should not be used elsewhere in your pattern
* `up` - the direction from which the pattern should be visible; `down` is also valid
