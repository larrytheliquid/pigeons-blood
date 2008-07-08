module PigeonsBlood
  def is_defined?(&block)
    ruby_contained_in_block = Ruby2Ruby.new.process(block.to_sexp).sub(/^proc \{/, '').sub(/\}$/, '')
    eval "defined? #{ruby_contained_in_block}", block
  end
end