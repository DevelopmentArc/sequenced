1.5.0 (December 26, 2013)
-------------------------

* Add the ability to pass a lambda for the start_at option (Bobby Uhlenbrock)
* Major internal refactor for cleaner, more modular code
* Scope by base class when single table inheritance is being used (Adam Becker)

1.4.0 (July 15, 2013)
---------------------

* Remove hard dependency on Rails 3 in the test suite
* Add skip option to sequence generation

1.3.0 (April 11, 2013)
----------------------

* Fix a potential bug that could overwrite previously set sequential IDs if
  they are later found to be non-unique.

1.2.0 (April 11, 2013)
----------------------

* Accept an array of symbols for the scope attribute to scope by multiple
  columns.

1.1.0 (July 5, 2012)
--------------------

* Raise ArgumentError instead of Sequenced::InvalidAttributeError
* Remove custom exceptions
* Stop calling it a "plugin"

1.0.0 (March 7, 2012)
---------------------

* Restrict dependencies on ActiveSupport and ActiveRecord to `~> 3.0`
* Make error messages more descriptive
* Update gem description


0.1.0 (February 19, 2012)
-------------------------

* Initial release