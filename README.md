NAME
----
  assassin.rb

SYNOPSIS
--------
  no zombies ever, not even on `exit!` or `kill -9`

USAGE
-----
```ruby
  pipe = IO.popen 'some-program-that-must-not-be-zombied'

  Assassin.at_exit_kill(pipe.pid)
```

  also see lib/assassin.rb and test/assassin_test.rb

DESCRIPTION
-----------
  assassin.rb is a small (~ 60 loc), simple, reliable methodology of ensuring
  that child processes are *always* cleaned up, regardless of the manner in
  which the parent program is shut down.

  the basic concept it to generate, start, and detach another script that
  monitors the parent process and, when that process no longer exists, ensures
  through escalation of signals that a child process is shut down and does not
  become a zombie.

  this becomes espcially important for libraries which spawn processes, such
  as via `IO.popen` that need to ensure those children are cleaned up, but
  which cannot control whether client code may call `exit`.  this approach
  also handles being `kill -9`d - something no `at_exit{}` handler can
  promise.

INSTALL
-------
  gem install assassin

URI
---
  http://github.com/ahoward/assassin

HISTORY
-------
  - 0.4.2. initial release
