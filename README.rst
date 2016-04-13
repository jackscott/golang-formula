===============
Golang-Formula
==============

Formula to setup and configure specific versions of `Golang`.
  "Go is an open source programming language that makes it easy to build simple, reliable, and efficient software."

  -- golang.org

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.


Available states
==================

.. contents::
   :local:

``golang``
------------
Install go!

``golang.debug``
-----------------
Helpful for debugging, dumps the jinja map to a text file

## Testing

Testing is done with `kitchen-salt<https://github.com/simonmcc/kitchen-salt>`_ which means you'll also need Ruby.  Hopefully you're already using rbenv or whatever all of the cool kids are using these days, I'm a fuddy-duddy and use rbenv.  This formula has been tested on both 1.9.3 and 2.2.2 versions of Ruby.

You should have `bundler` installed and have `bundle` on your $PATH, running this will set things up for Ruby.  If you're not running ruby-2.2.2 an exception will be thrown because the `Gemfile` is pinned to 2.2.2, update your Ruby version and re-run bundle command(s)

```
bundle

\\ or

bundle install
```

Once you have successfully bundled things up, you should have the `kitchen` command on your $PATH. The first part is to run `kitchen converge` which will setup the environment by
 - creating a vagrant box
 - install salt
 - run the states defined in **golang-formula/.kitchen.yml**
   

Once you've successfully `converged` the environment, the tests can be executed. If you were to run `kitchen verify` the tests found in `golang-formula/test/integration/default`. Currently there are only tests which use the `bats<https://blog.engineyard.com/2014/bats-test-command-line-tools>`_ ` `Busser<https://github.com/test-kitchen/busser>`_. 

You can also run the `kitchen test` command, but that will destroy the existing vagrant before converging, roughly:
```
kitchen destroy && kitchen converge && kitchen verify && kitchen destroy
```
which is useful for CI pipelines but not so much during dev.


## Author
[Jack Scott](https://github.com/jackscott) \<emacs+pinky@gmail.com\>
