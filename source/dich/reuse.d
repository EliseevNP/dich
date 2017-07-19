/**                                                                                                                                                  
  Copyright: 2017 © LLC CERERIS                                                                                                                      
  License: MIT                                                                                                                               
  Authors: LLC CERERIS                                                                                                                               
*/

module dich.reuse;

import dich.provider;

/// Interface for reuse object
interface ReuseInterface
{
  public:
    /** Get reuse object

      Params:
        key = Reuse object name
        provider = Object provider

      Returns:
        Reuse $(D Object)
    */
    Object get(string key, ProviderInterface provider);
}

/** Transient reuse object
  Returns the object directly
*/
class Transient: ReuseInterface
{
  public:
    /** Get transient reuse component 

      Params:
        key = Not used parameter
        provider = Object provider

      Returns:
        Reuse $(D Object)
    */
    override Object get(string key, ProviderInterface provider)
    {
      return provider.get;
    }
}

/** Singleton reuse object
  Guarantees that there is only one object for the given object name
*/
class Singleton: ReuseInterface
{
  public:
    /** Get singleton reuse component 

      Params:
        key = Unique name for Singleton
        provider = Object provider

      Returns:
        Reuse object
    */
    override Object get(string key, ProviderInterface provider)
    {
      if(key !in _instances)
      {
         _instances[key] = provider.get;
      }

      return _instances[key];
    }

  private:
    /// Object instance array for all singleton objects
    Object[string] _instances;
}
