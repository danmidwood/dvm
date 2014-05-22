DVM
====

##### Like RVM for [Dylan](http://opendylan.org/), but crappier

## Usage

DVM puts links to binaries in `~/.dvm/bin`, add it to your path.

### Install a version

From the root of a project run `dvm install $name $version`. Make sure everything is built first into a `_build` directory.

This will not symlink the version into your path, to do that..

### Use an installed version

From anywhere call `dvm use $name $version`.

### List available candidates

From anywhere call `dvm list` for a list of candidates, to see available versions for a candidate call `dvm list $name`.

### When things go wrong..

There's no error handling so error messages aren't very helpful.

This calls out to various unix commands (ls, ln, cp) so make sure they're available on your path.

## License

MIT Licensed, © Dan Midwood, 2014
