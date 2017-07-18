module test.dich.containertest;

import BDD;
import dich;

interface TestInterface
{
public:
    void test();
}
class TestClass: TestInterface
{
  public:
    void test(){}
}

unittest
{
  describe("Container get test", 
  	it("You can not get an unregistered object", delegate()  
      {
        auto container = new Container;
        shouldThrow(delegate()
          {
            container.get!TestInterface();
          },
          "Exception while resolving type test.dich.containertest.TestInterface: Type is not registered!");
      }
  	),
  	it("You can not get an unregistered object by name", delegate()
  	  {
        auto container = new Container;
        shouldThrow(delegate()
          {
            container.get!TestInterface("interfaceName");
          },
          "Exception while resolving type test.dich.containertest.TestInterface named interfaceName: Type is not registered!");
      }
    ),
  	it("You can not register two instances with one name", delegate()
  	  {
        auto container = new Container;
        shouldThrow(delegate()
          {
            container.register!TestInterface(new InstanceProvider(new TestClass()),"interfaceName");
            container.register!TestInterface(new InstanceProvider(new TestClass()),"interfaceName");
          },
          "Exception while registering type test.dich.containertest.TestInterface: Interface already bound!");
      }
    )
  );
}
