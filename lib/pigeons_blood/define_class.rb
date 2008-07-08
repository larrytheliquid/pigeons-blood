module PigeonsBlood
  def define_class(name, &block)
    eval %{class #{name}; end}, block
  end
end