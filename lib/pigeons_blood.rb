require 'rubygems'
require 'ruby2ruby'

module PigeonsBlood
  def is_defined?(&block)
    eval "defined? #{proc_contents_string(block)}", block
  end
  
  def class!(name, parent=nil, &block)
    eval %{class #{name}#{" < #{parent}" if parent}
            #{proc_contents_string(block)}
          end}, block
  end
  
private

  def proc_contents_string(proc)
    proc.to_ruby.sub(/^proc \{/, '').chomp('}')
  end
end