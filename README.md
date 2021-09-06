# Bash-Development

Following bash scripts are used to automate some initalization and installtions associated with [WordPress](https://wordpress.org/)

We will use the [WP CLI](https://wp-cli.org/de/) to make things even simpler.

In addition some functionalities of these scripts depend on a MacOS environment and a running [MAMP](https://www.mamp.info/de/mamp/mac/) server.

## Getting started

Export your MAMP root directory e.g. from .zshrc via

```console
foo@bar:~$ export MY_MAMP_ROOT_DIR='your-mamp-root-dir'
```

## Usage

### Create new WordPress System

```console
foo@bar:~$ ./new-wp.sh

usage: ./new-wp.sh <project-code> [dir-name]
```

### Delete a WordPress System

```console
foo@bar:~$ ./delete-wp.sh

usage: ./delete-wp.sh <project-code> [dir-name]
```
