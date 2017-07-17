module test.dich.instanceprovidertest.d;

import BDD;
import dich;

interface DummyInterface
{
  string test();
}

class DummyWithString: DummyInterface
{
  public:
    this(string value)
    {
      _value = value;
    }

    string test()
    {
      return _value;
    }

  private:
    string _value;
}

unittest
{
  describe("Register instance", 
    it("Register directly", delegate()
      {
        auto container = new Container;
        container.register!(DummyWithString, Singleton)(new DummyWithString("test"));

        auto service = container.get!DummyWithString();
        service.shouldNotBeNull();
        service.test.shouldEqual("test");
      }
    ),
    it("Register with InstanceProvider", delegate()
      {
        auto container = new Container;
        auto dummyProvider = new InstanceProvider(new DummyWithString("test test"));
        container.register!(DummyInterface, Singleton)(dummyProvider);

        auto service = container.get!DummyInterface();
        service.shouldNotBeNull();
        service.test.shouldEqual("test test");
      }
    ),
    it("Register many InstanceProvider for one interface", delegate()
      {
        auto container = new Container;
        auto dummyProvider1 = new InstanceProvider(new DummyWithString("1"));
        auto dummyProvider2 = new InstanceProvider(new DummyWithString("2"));
        container.register!(DummyInterface)(dummyProvider1, "1");
        container.register!(DummyInterface)(dummyProvider2, "2");

        auto service1 = container.get!DummyInterface("1");
        service1.shouldNotBeNull();
        service1.test.shouldEqual("1");

        auto service2 = container.get!DummyInterface("2");
        service2.shouldNotBeNull();
        service2.test.shouldEqual("2");

      }
    )
  );
}
