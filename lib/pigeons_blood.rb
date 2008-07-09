require 'rubygems'
require 'ruby2ruby'

module PigeonsBlood
  def is_defined?(&block)
    ruby_contained_in_block = Ruby2Ruby.new.process(block.to_sexp).sub(/^proc \{/, '').sub(/\}$/, '')
    eval "defined? #{ruby_contained_in_block}", block
  end
  
  def define_class(name, parent=nil, &block)
    klass = eval %{class #{name} < #{parent || 'Object'}; self; end}, block
    klass.class_eval "@define_block = block"    
    result = eval %{class #{name}; self.class_eval(&@define_block); end}, block    
    # klass.class_eval(&block)    
    klass.class_eval "@define_block = nil"
    result
  end
end