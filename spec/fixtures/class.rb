module ClassSpecs
  class!(:A) {}
  
  class!(:B) do
    @@cvar = :cvar
    @ivar = :ivar
  end
  
  class!(:C) do
    def self.make_class_variable
      @@cvar = :cvar
    end

    def self.make_class_instance_variable
      @civ = :civ
    end
  end
  
  class!(:D) do
    def make_class_variable
      @@cvar = :cvar
    end
  end
  
  class!(:E) do
    def self.cmeth() :cmeth end
    def meth() :meth end
    
    class << self
      def smeth() :smeth end
    end
    
    CONSTANT = :constant!
  end
  
  class!(:F) {}
  class!(:F) do
    def meth() :meth end
  end
  class!(:F) do
    def another() :another end
  end
  
  class!(:G) do
    def override() :nothing end
    def override() :override end
  end
  
  class!(:Container) do    
    class!(:A) {}
    class!(:B) {}    
    # class A; end
    # class B; end
  end

  O = Object.new
  class << O
    def smeth
      :smeth
    end
  end
  
  class!(:H) do
    def self.inherited(sub)
      track_inherited << sub
    end
    
    def self.track_inherited
      @inherited_modules ||= []
    end
  end
  
  class!(:K, :H) {}
  
  class!(:I) do    
    class!(:J, :self) {}
  end
end
