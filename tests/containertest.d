module test.dich.containertest;

import BDD;
import dich;
import test.dich.instanceprovidertest;

interface TestInterface
{
  public:
    void test();
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
      }, "Exception while resolving type test.dich.containertest.TestInterface: Type is not registered!");
    }
  ));
}
