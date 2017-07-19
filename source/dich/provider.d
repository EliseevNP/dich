/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module dich.provider;

/// Provides objects
interface ProviderInterface
{
  public:
    /** Get object

      Returns:
        Provided $(D Object)
    */
    Object get();
}

/// Provides objects for DI
class InstanceProvider: ProviderInterface
{
  public:
    /// Creates an InstanceProvider object
    this(Object instance)
    {
      _instance = instance;
    }

	/** Get object

      Returns:
        Provided $(D Object)
    */
    Object get()
    {
      return _instance;
    }

  private:
    Object _instance;
}
