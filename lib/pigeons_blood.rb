require 'rubygems'
require 'ruby2ruby'

module PigeonsBlood
  def is_defined?(&block)
    eval "defined? #{proc_contents_string(block)}", block
  end
  
  def class!(name, parent=nil, &block)
    eval %{class #{parse_class_argument(name)}#{" < #{parse_class_argument(parent)}" if parent}
            #{proc_contents_string(block)}
          end}, block
  end
  
  def def!(name, *arguments, &block)
    eval %{def #{name}(#{arguments.map{|argument| parse_def_argument(argument) }.join(", ")})
            #{proc_contents_string(block)}
          end}, block
  end
  
private

  def proc_contents_string(proc)
    proc.to_ruby.sub(/^proc \{/, '').chomp('}')
  end
  
  def parse_class_argument(argument)
    case argument
    when Array then argument.join('::')
    else argument
    end
  end
  
  def parse_def_argument(argument)
    case argument
    when Array
      case argument.first.to_sym
      when :*, :& then argument.join
      else argument.reverse.join('=')
      end
    else
      argument
    end
  end
end