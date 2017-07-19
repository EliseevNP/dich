/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module dich.binding;

import dich.provider;
import dich.reuse;

/// Provides DI binding. Represents a registered binding in that library
struct Binding
{  
  public:
    /// Full name of a registered binding
    string fullyQualifiedName;
    
    /// A name of binding for getting it by name
    string name;
    
    /// Provider of that binding
    ProviderInterface provider;
    
    /// Reuse interface of that binding
    ReuseInterface reuse;
}
