module Kernel
  def is_defined?(binding, &block)
    ruby_contained_in_block = Ruby2Ruby.new.process(block.to_sexp).sub(/^proc \{/, '').sub(/\}$/, '')
    eval "defined? #{ruby_contained_in_block}", binding
  end
end