# Building mulang from source

## Setup

To generate `mulang` executable, you have to build the project using [stack](https://haskellstack.org):

1. Install stack: `wget -qO- https://get.haskellstack.org/ | sh`
2. Go to the mulang project directory and setup it: `stack setup`
3. Build the project: `stack build`

## Installing and creating an executable


```bash
$ stack install
$ mulang
```

That will generate a `mulang` executable in the folder `~/.local/bin`.

## Running tests

```bash
$ stack test --fast
```

## Watching changes


```bash
$ stack test --fast --file-watch
```

## Loading mulang in the REPL

```bash
stack ghci
```

# Ruby wrapper

This module can also be deployed a ruby gem. `mulang` works with Ruby 2.3+

## Building

```bash
cd gem
rake wrapper:wrap
bundle install
bundle exec rspec
```

## Installing from rubygems

Mulang is already shipped as a ruby gem:

```
gem install mulang
```

See `gem/README` for more details.

# JavaScript library

`mulang` can also be compiled to JavaScript library using [ghcjs](https://github.com/ghcjs/ghcjs) and [ghcjslib](https://github.com/flbulgarelli/ghcjslib), which allows you to use it from `node` or the browser.

## Building

> :warning: you will need `node >= 7` installed on your system. If you have `nvm`, before starting run the following:
>
> ```sh
> $ nvm use $(cat ghcjslib/.nvmrc)
>```

```bash
# 1. Swap to GHCJS compiler
ghcjslib/swap.sh
# 2. Build ghcjslib release. It will be placed on ghcjslib/build/mulang.js
ghcjslib/build.sh
# 3. Run both mocha and hspec tests.
ghcjslib/test.sh
# 4. Run again for swapping back to ghc
ghcjslib/swap.sh
```

## Loading

1. in the browser: `google-chrome ghcjslib/index.html`
2. in `node`: run `node`, and then, within the interpreter, run: `let mulang = require('./ghcjslib/build/mulang.js');`

## Running

Try it using `mulang.analyse(...pass here a spec as described in the README....)`. For example:

```javascript
> mulang.analyse({
    "sample" : {
        "tag" : "CodeSample",
        "language" : "Haskell",
        "content" : "x = 1"
      },
    "spec" : {
        "smellsSet" : { "tag" : "NoSmells" },
        "expectations" : [
            {
                "binding" : "*",
                "inspection" : "Declares:x"
              }
        ]
      }
})
```

## Installing from npm

Mulang is already shipped as an npm package:

```
npm install mulang
```

See `ghcjslib/README` and https://www.npmjs.com/package/mulang for more details.

# Tagging and releasing

```bash
./tag.sh
```

# Updating docs

These site is build using `mkdocs >= 0.17`. You can install it using  `pip`:

```bash
$ pip install mkdocs
```

From the project root folder, running `mkdocs serve` will serve the files in a local server, `mkdocs build` will build the static site to a foldes called `site`, and deploys to the `gh-pages` branch are done by running `mkdocs gh-deploy` directly.