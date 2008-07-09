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
  
  define_class(:F) {}
  define_class(:F) do
    def meth() :meth end
  end
  define_class(:F) do
    def another() :another end
  end
  
  define_class(:G) do
    def override() :nothing end
    def override() :override end
  end
  
  define_class(:Container) do    
    class A; end
    class B; end
  end

  O = Object.new
  class << O
    def smeth
      :smeth
    end
  end
  
  define_class(:H) do
    def self.inherited(sub)
      track_inherited << sub
    end
    
    def self.track_inherited
      @inherited_modules ||= []
    end
  end
  
  define_class(:K, :H) {}
  
  define_class(:I) do    
    class J < self 
    end
  end
end
