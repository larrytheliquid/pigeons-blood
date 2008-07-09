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
  
  def def!(name, *arguments, &block)
    eval %{def #{name}(#{arguments.map{|argument| parse_argument(argument) }.join(", ")})
            #{proc_contents_string(block)}
          end}, block
  end
  
private

  def proc_contents_string(proc)
    proc.to_ruby.sub(/^proc \{/, '').chomp('}')
  end
  
  def parse_argument(argument)
    case argument
    when Array
      case argument.first.to_s
      when '*', '&' then argument.join
      else argument.reverse.join("=")
      end
    else
      argument
    end
  end
end