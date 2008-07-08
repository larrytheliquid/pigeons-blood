module PigeonsBlood
  def define_class(binding, name, &block)
    eval %{class #{name}; end}, binding
  end
end