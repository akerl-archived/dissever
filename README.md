dissever
=========

[![Gem Version](https://img.shields.io/gem/v/dissever.svg)](https://rubygems.org/gems/dissever)
[![Build Status](https://img.shields.io/travis/com/akerl/dissever.svg)](https://travis-ci.com/akerl/dissever)
[![Coverage Status](https://img.shields.io/codecov/c/github/akerl/dissever.svg)](https://codecov.io/github/akerl/dissever)
[![Code Quality](https://img.shields.io/codacy/5e1e365eebf142d9b9d462a75dd2fcec.svg)](https://www.codacy.com/app/akerl/dissever)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

Simple library for multiprocessing tasks

## Usage

Build an array of [name, &block] pairs and hand it to Dissever:

```
require 'dissever'

tasks = 1.upto(10).map { |x| ["Job #{x}", proc { Process.pid }] }
processor = Dissever.new(tasks: tasks)
result = processor.run!
# Value of result
# {"Job 1"=>24966, "Job 2"=>24967, "Job 3"=>24968, "Job 4"=>24969, "Job 5"=>24970, "Job 6"=>24971, "Job 7"=>24972, "Job 8"=>24973, "Job 9"=>24974, "Job 10"=>24975}
```

You can also pass in tasks as a block. The following code is equivalent to the above:

```
require 'dissever'

processor = Dissever.new(tasks: tasks) do
  1.upto(10).map { |x| ["Job #{x}", proc { Process.pid }] }
end
result = processor.run!
# Value of result
# {"Job 1"=>24986, "Job 2"=>24987, "Job 3"=>24988, "Job 4"=>24989, "Job 5"=>24990, "Job 6"=>24991, "Job 7"=>24992, "Job 8"=>24993, "Job 9"=>24994, "Job 10"=>24995}
```

If you don't want it to print the progress bar, you can call Dissever.new(quiet: true).

It defaults to running with a pool of 10 processes. You can tune this with the size parameter (`Dissever.new(size: 20)`).

## Installation

    gem install dissever

## License

dissever is released under the MIT License. See the bundled LICENSE file for details.

