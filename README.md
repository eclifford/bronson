# Bronson Local Environment Setup

The purpose of this `gh-pages` branch is for hosting a reference guide of BronsonJS via Github pages. The following steps are what's needed to get your local environment setup for collaboration:

## Installation

### Install Jekyll
As shown in the official [Jekyll installation documentation](https://github.com/mojombo/jekyll/wiki/Install):

```bash
$ gem install jekyll
```

### Install Pygments

To get proper syntax highlighting of code you will need to [install pygments](http://pygments.org/docs/installation/).

```bash
$ sudo easy_install Pygments
```

## Running Locally

Spin up a local server:

```bash
$ jekyll --server
```

Now you can view this branch at [http://localhost:4000](http://localhost:4000).
