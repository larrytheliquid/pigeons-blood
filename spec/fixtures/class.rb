module ClassSpecs
  define_class(:A) {}
  
  define_class(:B) do
    @@cvar = :cvar
    @ivar = :ivar
  end
  
  define_class(:C) do
    def self.make_class_variable
      @@cvar = :cvar
    end

    def self.make_class_instance_variable
      @civ = :civ
    end
  end
  
  define_class(:D) do
    def make_class_variable
      @@cvar = :cvar
    end
  end
  
  define_class(:E) do
    def self.cmeth() :cmeth end
    def meth() :meth end
    
    class << self
      def smeth() :smeth end
    end
    
    CONSTANT = :constant!
  end
  
  class F; end
  class F
    def meth() :meth end
  end
  class F
    def another() :another end
  end
  
  class G
    def override() :nothing end
    def override() :override end
  end
  
  class Container
    class A; end
    class B; end
  end

  O = Object.new
  class << O
    def smeth
      :smeth
    end
  end
  
  class H
    def self.inherited(sub)
      track_inherited << sub
    end
    
    def self.track_inherited
      @inherited_modules ||= []
    end
  end
  
  class K < H; end
  
  class I
    class J < self 
    end
  end
end
