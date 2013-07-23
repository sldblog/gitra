## Git repository analyser

(The too-soon version)

[![Build Status](https://travis-ci.org/sldblog/gitra.png?branch=master)](https://travis-ci.org/sldblog/gitra)

### Usage

```
Usage: gitra [options]
    -a, --analyse [BRANCH]           Analyze the repository in relation the the specified branch (defaults to master).
    -l, --log SINCE_REV              Shows the stories and bugs committed since the specified revision.
    -m, --matching [BRANCHES]        Comma separated list of branches to match
```

### Sample use case

Given the following git repository:

```
$ git log --oneline --graph --all --decorate
* 0fbdc16 (HEAD, master) master #3
*   08a0df3 Merge branch 'test'
|\
* | 23e7058 master #2
* | b4c12ca master #1
| | * 08e7339 (test) test #3
| |/
| * af75469 test #2
| * de14754 test #1
|/
* 6530d98 first
```

You can analyse the ahead/behind information using `gitra`.

By default, it analyses the active branch in the repository it is in (you have to be physically in the repo directory for now):

```
$ git branch
* master
  test
```

```
$ gitra -a
---- Analyzing branches in relation to master ----
Analysing 2 branches: ..
master merged
  test 1 ahead (unmerged), (but 2 behind)
```

You can specify any branches as part of the command line:

```
$ gitra -a test
---- Analyzing branches in relation to test ----
Analysing 2 branches: ..
  test merged
master 2 ahead (unmerged), (but 1 behind)
```

As you can see, the reported information is in line compared to the repository graph displayed above:
- `master` is indeed ahead by 2 commits (`08a0df3`, `0fbdc16`), but missing 1 (`08e7339`), when viewed from `test` branch
- the other way around if viewed from the `master` branch

This kind of analysis really helps our current team to get on top of the current branching strategy we inherited.

### License

MIT license.
