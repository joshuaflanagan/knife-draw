# Knife Draw plugin for Chef

Generates pictures of your Chef environment

## Installation

    $ gem install knife-draw

## Usage

```
knife draw nodes               # creates output.png image of all environments
knife draw nodes -E production # only nodes in production environment
knife draw nodes output.dot    # creates output in DOT format
```

```
knife draw roles              # creates output.png image
knife draw roles myroles.jpg  # creates myroles.jpg image
```

The output file format is inferred based on the file extension.
Supports all formatted supported by the Graphviz `dot` command.

All commands also support the command line options:

```
-V    verbose output. Output the Chef data used to build the drawing.
--color     Use color in the generated image (default)
--no-color  Do not use color in the generated image
```

## Contributing

1. Fork it ( https://github.com/joshuaflanagan/knife-draw/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
