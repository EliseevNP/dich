module dich.binding;

import dich.provider;
import dich.reuse;

package struct Binding
{
  public:
   string fullyQualifiedName;
   string name;
   ProviderInterface provider;
   ReuseInterface reuse;
}
