/**                                                                                                                                                  
  Copyright: 2017 © LLC CERERIS                                                                                                                      
  License: MIT                                                                                                                               
  Authors: LLC CERERIS                                                                                                                               
*/

module dich.provider;

///
interface ProviderInterface
{
  public:
    Object get();
}

class InstanceProvider: ProviderInterface
{
  public:
    this(Object instance)
    {
      _instance = instance;
    }

    Object get()
    {
      return _instance;
    }

  private:
    Object _instance;
}
