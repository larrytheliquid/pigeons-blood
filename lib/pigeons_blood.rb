require 'rubygems'
require 'ruby2ruby'

module PigeonsBlood
  def is_defined?(&block)
    eval "defined? #{proc_to_ruby(block)}", block
  end
  
  def define_class(name, parent=nil, &block)
    eval %{class #{name} < #{parent || 'Object'}
            #{proc_to_ruby(block)}
          end}, block
  end
  
private

  def proc_to_ruby(proc)
    proc.to_ruby.sub(/^proc \{/, '').sub(/\}$/, '')
  end
end