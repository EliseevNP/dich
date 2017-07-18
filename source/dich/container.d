module dich.container;

import dich.binding;
import dich.exception;
import dich.provider;
import dich.reuse;
import std.algorithm;
import std.array;
import std.traits;

class Container
{
  public:
    this()
    {
      bindReuse!Transient;
      bindReuse!Singleton;
    }

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

    void register(C, R: ReuseInterface = Transient)(C instance)
    {
      register!(C, R)(new InstanceProvider(instance), "");
    }

    void register(I, R: ReuseInterface = Transient)(ProviderInterface provider)
    {
      this.register!(I, R)(provider, "");
    }

    void register(I, R: ReuseInterface = Transient)(ProviderInterface provider, string name)
    {
      if(exists!I(name))
      {
        throw new RegistrationException("Interface already bound!", fullyQualifiedName!I);
      }

      _bindings ~= createBinding!(I, R)(provider, name);
    }

    I get(I)(string name)
    {
      Binding[] binding = filterExactly!I(name);
      if(binding.empty)
      {
        throw new ResolveException("Type is not registered!", fullyQualifiedName!I, name);
      }

      return resolve!I(binding[0]);
    }

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
