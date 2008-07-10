require 'rubygems'
require 'ruby2ruby'

module PigeonsBlood
  def is_defined?(&block)
    eval "defined? #{proc_contents(block)}", block
  end
  
  def class!(name, parent=nil, &block)
    eval %{class #{parse_class_name(name)}#{" < #{parse_class_name(parent)}" if parent}
            #{proc_contents(block)}
          end}, block
  end
  
  def def!(name, *arguments, &block)
    eval %{def #{parse_def_name(name)}(#{arguments.map{|argument| parse_def_argument(argument) }.join(", ")})
            #{proc_contents(block)}
          end}, block
  end
  
private

  def proc_contents(proc)
    proc.to_ruby.sub(/^proc \{/, '').chomp('}')
  end
  
  def parse_class_name(name)
    case name
    when Array then name.join('::')
    else name
    end
  end
  
  def parse_def_name(name)
    case name
    when Array then name.join('.')
    else name
    end
  end
  
  def parse_def_argument(argument)
    case argument
    when Array
      case argument.first.to_sym
      when :*, :& then argument.join
      else argument.join('=')
      end
    else
      argument
    end
  end
end