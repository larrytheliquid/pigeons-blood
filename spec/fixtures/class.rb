module ClassSpecs
  class!(:A) {}
  
  class!(:B) do
    @@cvar = :cvar
    @ivar = :ivar
  end
  
  class!(:C) do
    def!([:self, :make_class_variable]) do
      @@cvar = :cvar
    end

    def!([:self, :make_class_instance_variable]) do
      @civ = :civ
    end
  end
  
  class!(:D) do
    def!(:make_class_variable) do
      @@cvar = :cvar
    end
  end
  
  class!(:E) do
    def!([:self, 'cmeth()']) {:cmeth}
    def!(:meth) {:meth}
    
    class << self
      def smeth; :smeth; end
    end
    
    CONSTANT = :constant!
  end
  
  class!(:F) {}
  class!(:F) do
    def!(:meth) {:meth}
  end
  class!(:F) do
    def!(:another) {:another}
  end
  
  class!(:G) do
    def!(:override) {:nothing}
    def!(:override) {:override}
  end
  
  class!(:Container) do    
    class!(:A) {}
    class!(:B) {}    
  end

  O = Object.new
  class << O
    def!(:smeth) do
      :smeth
    end
  end
  
  class!(:H) do
    def!([:self, :inherited], :sub) do
      track_inherited << sub
    end
    
    def!([:self, :track_inherited]) do
      @inherited_modules ||= []
    end
  end
  
  class!(:K, :H) {}
  
  class!(:I) do    
    class!(:J, :self) {}
  end
end
