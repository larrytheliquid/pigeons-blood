require File.dirname(__FILE__) + '/spec_helper'

describe PigeonsBlood, "#is_defined?" do
  class LanguageDefinedSpecs
    SomeConst = 5

    def no_args
    end
    def args(x)
    end

    def lvar_defined
      x = 1
      is_defined?(binding) { x }
    end
  end
  
  class LanguageDefinedSubclass < LanguageDefinedSpecs
    def no_args
      is_defined?(binding) { super }
    end
    def args
      is_defined?(binding) { super() }
    end
  end

  module A
    self::FOO = 'x' unless is_defined?(binding) { self::FOO } rescue nil
  end
  
  it "returns 'method' when is_defined?(binding) { exit } is sent" do
    ret = is_defined?(binding) { exit }
    ret.should == 'method'
  end

  it "returns 'method' when is_defined?(binding) { Kernel.puts } is sent" do
    ret = is_defined?(binding) { Kernel.puts }
    ret.should == 'method'
  end

  it "returns nil when is_defined?(binding) { DoesNotExist.puts } is sent" do
    ret = is_defined?(binding) { DoesNotExist.puts }
    ret.should == nil
  end

  it "returns nil when is_defined?(binding) { Kernel.does_not_exist } is sent" do
    ret = is_defined?(binding) { Kernel.does_not_exist }
    ret.should == nil
  end

  it "returns 'assignment' when is_defined?(binding) { x = 2 } is sent" do
    ret = is_defined?(binding) { x = 2 }
    ret.should == 'assignment'
  end

  it "returns 'local-variable' when x = 1; is_defined?(binding) { x } is sent" do
    obj = LanguageDefinedSpecs.new
    obj.lvar_defined.should == 'local-variable'
  end

  it "returns 'constant' when is_defined?(binding) { Object } is sent" do
    ret = is_defined?(binding) { Object }
    ret.should == 'constant'
  end

  it "returns 'class variable' when @@x = 1; is_defined?(binding) { @@x } is sent" do
    @@x = 1
    ret = is_defined?(binding) { @@x }
    ret.should == 'class variable'
  end

  it "returns 'instance-variable' when @x = 1; is_defined?(binding) { @x } is sent" do
    @x = 1
    ret = is_defined?(binding) { @x }
    ret.should == 'instance-variable'
  end

  it "returns 'global-variable' when $x = 1; is_defined?(binding) { $x } is sent" do
    $x = 1
    ret = is_defined?(binding) { $x }
    ret.should == 'global-variable'
  end

  it "returns 'expression' when is_defined?(binding) { 'foo = bar' } is sent" do
    ret = is_defined?(binding) { 'foo = bar' }
    ret.should == "expression"
  end

  it "returns 'self' when is_defined?(binding) { self } is sent" do
    ret = is_defined?(binding) { self }
    ret.should == "self"
  end

  it "returns 'nil' when is_defined?(binding) { nil } is sent" do
    ret = is_defined?(binding) { nil }
    ret.should == "nil"
  end

  it "returns 'true' when is_defined?(binding) { true } is sent" do
    ret = is_defined?(binding) { true }
    ret.should == "true"
  end

  it "returns 'false' when is_defined?(binding) { false } is sent" do
    ret = is_defined?(binding) { false }
    ret.should == "false"
  end

  it "returns nil when is_defined?(binding) { no_such_local } is sent" do
    ret = is_defined?(binding) { no_such_local }
    ret.should == nil
  end

  it "returns 'expression' when is_defined?(binding) { :File } is sent" do
    ret = is_defined?(binding) { :File }
    ret.should == "expression"
  end

  it "returns 'constant' when is_defined?(binding) { LanguageDefinedSpecs::SomeConst } is sent" do
    ret = is_defined?(binding) { LanguageDefinedSpecs::SomeConst }
    ret.should == "constant"
  end

  it "returns 'constant' when evaluating self::FOO in module A" do
    ret = is_defined?(binding) { A::FOO }
    ret.should == 'constant'
  end

  it "returns 'constant' when is_defined?(binding) { File } is sent" do
    ret = is_defined?(binding) { File }
    ret.should == "constant"
  end

  it "returns 'constant' when is_defined?(binding) { File::SEPARATOR } is sent" do
    ret = is_defined?(binding) { File::SEPARATOR }
    ret.should == "constant"
  end

  it "returns 'method' when is_defined?(binding) { Object.nil? } is sent" do
    ret = is_defined?(binding) { Object.nil? }
    ret.should == "method"
  end

  it "returns 'expression' when is_defined?(binding) { 0 } is sent" do
    ret = is_defined?(binding) { 0 }
    ret.should == "expression"
  end

  # compliant_on :rubinius do
  #   # Rubinius does not care about dynamic vars
  #   it "returns 'local-variable' when defined? is called on a block var" do
  #     block = Proc.new { |x| is_defined?(binding) { x } }
  #     ret = block.call(1)
  #     ret.should == 'local-variable'
  #   end
  # end
  # 
  # # I (Evan) am not certain we'll support is_defined?(binding) { super } ever.
  # # for now, i'm marking these as compliant.
  # compliant_on :ruby do
  #   it "returns 'super' when Subclass#no_args uses defined?" do
  #     ret = (LanguageDefinedSpecs::LanguageDefinedSubclass.new.no_args)
  #     ret.should == "super"
  #   end
  # 
  #   it "returns 'super' when Subclass#args uses defined?" do
  #     ret = (LanguageDefinedSpecs::LanguageDefinedSubclass.new.args)
  #     ret.should == "super"
  #   end
  # 
  #   it "returns 'local-variable' when defined? is called on a block var" do
  #     block = Proc.new { |xxx| is_defined?(binding) { xxx } }
  #     ret = block.call(1)
  #     ret.should == 'local-variable(in-block)'
  #   end
  # 
  # end
end
