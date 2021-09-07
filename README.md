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

### Fast usage with aliases

Create aliases in e.g. .zshrc via

```console
new-wp() {
    your/path/to/file/new-wp.sh $1 $2
}

delete-wp() {
    your/path/to/file/delete-wp.sh $1 $2
}
```
