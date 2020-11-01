# blocks-in-space
### _ava fox_

this program is a bot that watches the federated timeline and blocks any user from botsin.space that it sees.

## Usage

edit sample.config to include an access token for your account,
your mastodon instance,
and an optional list of usernames to not block

run the program and specify the config file as a command line argument 

`./blocks-in-space my.config`

## Building
- install a lisp ([roswell](https://github.com/roswell/roswell))
- run the following commands (`$` denotes a system shell, `*` denotes a lisp shell)

```
$ git clone https://github.com/compufox/blocks-in-space ~/common-lisp/blocks-in-space 
$ ros run
* (ql:quickload :blocks-in-space)
* (asdf:make :blocks-in-space)
```

if no errors occur then the binary (with supporting libraries) should be in `~/common-lisp/blocks-in-space/bin`

## License

NPLv1+

