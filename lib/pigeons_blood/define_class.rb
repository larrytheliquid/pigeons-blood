module PigeonsBlood
  def define_class(name, parent=nil, &block)
    klass = eval %{class #{name} < #{parent || 'Object'}; self; end}, block
    klass.instance_eval(&block)
  end
end