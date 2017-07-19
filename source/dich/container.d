/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module dich.container;

import dich.binding;
import dich.exception;
import dich.provider;
import dich.reuse;
import std.algorithm;
import std.array;
import std.traits;

/// Provides DI entity. Represents a container to register instances with provider
class Container
{
  public:
    /// Creates a Container object
    this()
    {
      bindReuse!Transient;
      bindReuse!Singleton;
    }

	/** Register reuse interfaces
	
	  Params:
		Class = Class instance to register reuse interface (Transient, Singleton)
    */
    void bindReuse(Class)()
    {
      immutable key = fullyQualifiedName!Class;
      assert(key.length > 0);
      if (key in _scopes)
      {
        throw new Exception("Scope already bound");
      }
      _scopes[key] = new Class();
    }

	/** Register reuse objects
	
	  Params:
	    R = Reuse interface (Transient, Singleton)
		instance = Object of C class to register in container
		
	  Examples:
        ---
        class MyClass{};
        
		auto container = new Container();
		auto myClass = new MyClass();
		container.register!(MyClass)(myClass);
		---
    */
    void register(C, R: ReuseInterface = Transient)(C instance)
    {
      register!(C, R)(new InstanceProvider(instance), "");
    }

	/** Register reuse objects through InstanceProvider
	
	  Params:
	    I = Interface type
	    R = Reuse interface (Transient, Singleton)
		provider = Object of InstanceProvider class to register in container
		
	  Examples:
        ---
        interface MyInterface{};
        class MyClass: MyInterface{};
        
		auto container = new Container();
		auto myClassInstance = new InstanceProvider(new MyClass());
		container.register!(MyInterface)(myClassInstance);
		---
    */
    void register(I, R: ReuseInterface = Transient)(ProviderInterface provider)
    {
      this.register!(I, R)(provider, "");
    }

	/** Register reuse objects through InstanceProvider specifying its name
	
	  Params:
	    I = Interface type
	    R = Reuse interface (Transient, Singleton)
		provider = Object of InstanceProvider class to register in container
		name = A string which allows to get instances by its name
		
	  Examples:
        ---
        interface MyInterface{};
        class MyClass: MyInterface{};
        
		auto container = new Container();
		auto myClassInstance = new InstanceProvider(new MyClass());
		container.register!(MyInterface)(myClassInstance, "My best class");
		---
    */
    void register(I, R: ReuseInterface = Transient)(ProviderInterface provider, string name)
    {
      if(exists!I(name))
      {
        throw new RegistrationException("Interface already bound!", fullyQualifiedName!I);
      }

      _bindings ~= createBinding!(I, R)(provider, name);
    }

	/** Get reuse objects by its name
	
	  Params:
	    I = Interface type
		name = Name of instance specified in register function
		
	  Examples:
        ---
        interface MyInterface{};
        class MyClass: MyInterface{};
        
		auto container = new Container();
		auto myClassInstance = new InstanceProvider(new MyClass());
		container.register!(MyInterface)(myClassInstance, "My best class");
		auto myClass = container.get!(MyInterface)("My best class");
		---

	  Returns:
	    Instance as an interface type
    */
    I get(I)(string name)
    {
      Binding[] binding = filterExactly!I(name);
      if(binding.empty)
      {
        throw new ResolveException("Type is not registered!", fullyQualifiedName!I, name);
      }

      return resolve!I(binding[0]);
    }

	/** Get reuse objects by its class
	  Params:
	    T = Interface type
	  
	  Examples:
        ---
        interface MyInterface{};
        class MyClass: MyInterface{};
        
		auto container = new Container();
		auto myClassInstance = new InstanceProvider(new MyClass());
		container.register!(MyInterface)(myClassInstance)
		auto myClass = container.get!(MyInterface)();
		---

	  Returns:
	    Instance as an interface type
    */
    T get(T)()
    {
      // If want get array
      static if(is(T t == I[], I))
      {
        // TODO: make array get
      }
      else
      {
        Binding[] bindings = filterExactly!T("");
        if(bindings.empty)
        {
          throw new ResolveException("Type is not registered!", fullyQualifiedName!T);
        }

        return resolve!T(bindings[0]);
      }
    }

  private:
    bool exists(I)(string name)
    {
      return !filterExactly!I(name).empty;
    }

    Binding[] filterExactly(I)(string name)
    {
      string requestedFullyQualifiedName = fullyQualifiedName!I;
      return _bindings.filter!(a => a.fullyQualifiedName == requestedFullyQualifiedName && a.name == name).array;
    }

    I resolve(I)(Binding binding)
    {
      string key = fullyQualifiedName!I;
      if(binding.name.length > 0)
      {
        key ~= binding.name;
      }

      return cast(I) binding.reuse.get(key, binding.provider);
    }

    Binding createBinding(I, R)(ProviderInterface provider, string name)
    {
      auto reuse = _scopes[fullyQualifiedName!R];
      return Binding(fullyQualifiedName!I, name, provider, reuse);
    }

  private:
    Binding[] _bindings;
    ReuseInterface[string] _scopes;
}
