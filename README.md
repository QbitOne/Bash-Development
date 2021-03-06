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

### Migrate remote WordPress System

```console
foo@bar:~$ ./remote-wp.sh

usage: ./remote-wp.sh <domain> <ssh-user> <project-code> [remote-path] [dir-name]

<domain>          e.g. domain.de
<ssh-user>        e.g. user123
<project-code>    e.g. pjc
[remote-path]     -> /html/wordpress/
[dir-name]        -> wp-local
```

### Start local project

```console
foo@bar:~$ ./start-dev.sh

usage: ./start-dev.sh <project-code> [dir-name]
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

remote-wp() {
    your/path/to/file/remote-wp.sh $1 $2 $3 $4 $5
}

start-dev() {
    your/path/to/file/start-dev.sh $1 $2
}
```

## Default plugin installation

After confirmation, following default plugins will be installed

- [view-admin-as](https://wordpress.org/plugins/view-admin-as/)
- [query-monitor](https://wordpress.org/plugins/query-monitor/)
- [advanced-custom-fields](https://wordpress.org/plugins/advanced-custom-fields/)
- [enable-media-replace](https://wordpress.org/plugins/enable-media-replace/)
- [contact-form-7](https://wordpress.org/plugins/contact-form-7/)
