/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module dich.exception;

import std.string;

/// Provides an Exception when trying to get an unregistered instance
class ResolveException: Exception
{
  public:
    /** Creates a ResolveException object
    
      Params:
        message = An exception message
        key = A type of an exceptioned object
        name = A name of an exceptioned object
    */
    this(string message, string key, string name)
    {
      super(format("Exception while resolving type %s named %s: %s", key, name, message));
    }

    /** Creates a ResolveException object
    
      Params:
        message = An exception message
        key = A type of an exceptioned object
    */
    this(string message, string key)
    {
      super(format("Exception while resolving type %s: %s", key, message));
    }
}

/// Provides an Exception when trying to register an instance twice
class RegistrationException : Exception
{
  public:
    /** Creates a RegistrationException object
    
      Params:
        message = An exception message
        key = A type of an exceptioned object
    */
    this(string message, string key)
    {
      super(format("Exception while registering type %s: %s", key, message));
    }
}
