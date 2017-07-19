module dich.exception;

import std.string;

/// Provides an Exception when trying to get an unregistered instance
class ResolveException: Exception
{
  public:
    this(string message, string key, string name)
    {
      super(format("Exception while resolving type %s named %s: %s", key, name, message));
    }

    this(string message, string key)
    {
      super(format("Exception while resolving type %s: %s", key, message));
    }
}

/// Provides an Exception when trying to register an instance twice
class RegistrationException : Exception
{
  public:
    this(string message, string key)
    {
      super(format("Exception while registering type %s: %s", key, message));
    }
}
