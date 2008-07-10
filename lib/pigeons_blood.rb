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

  def unify(sexp)
    Unifier.new.process(sexp)
  end

  def proc_contents(proc)
    #   >> lambda { |x| x + 2 }.to_sexp
    #   => [:iter, [:fcall, :proc], [:dasgn_curr, :x], [:call, [:dvar, :x], :+, [:array, [:lit, 2]]]]
    iter, fcall, local_assigns, body = unify(proc.to_sexp)
    ruby2ruby = Ruby2Ruby.new

    if local_assigns
      "|#{ruby2ruby.process(local_assigns)}| #{ruby2ruby.process(body)}"
    else
      ruby2ruby.process(body)
    end
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