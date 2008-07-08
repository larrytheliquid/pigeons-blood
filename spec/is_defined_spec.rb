require File.join(File.dirname(__FILE__), 'spec_helper')

describe PigeonsBlood, "#is_defined?" do
  class LanguageDefinedSpecs
    SomeConst = 5

    def no_args
    end
    def args(x)
    end

    def lvar_defined
      x = 1
      is_defined? { x }
    end
  end
  
  class LanguageDefinedSubclass < LanguageDefinedSpecs
    def no_args
      is_defined? { super }
    end
    def args
      is_defined? { super() }
    end
  end

  module A
    self::FOO = 'x' unless is_defined? { self::FOO } rescue nil
  end
  
  it "returns 'method' when is_defined? { exit } is sent" do
    ret = is_defined? { exit }
    ret.should == 'method'
  end

  it "returns 'method' when is_defined? { Kernel.puts } is sent" do
    ret = is_defined? { Kernel.puts }
    ret.should == 'method'
  end

  it "returns nil when is_defined? { DoesNotExist.puts } is sent" do
    ret = is_defined? { DoesNotExist.puts }
    ret.should == nil
  end

  it "returns nil when is_defined? { Kernel.does_not_exist } is sent" do
    ret = is_defined? { Kernel.does_not_exist }
    ret.should == nil
  end

  it "returns 'assignment' when is_defined? { x = 2 } is sent" do
    ret = is_defined? { x = 2 }
    ret.should == 'assignment'
  end

  it "returns 'local-variable' when x = 1; is_defined? { x } is sent" do
    obj = LanguageDefinedSpecs.new
    obj.lvar_defined.should == 'local-variable'
  end

  it "returns 'constant' when is_defined? { Object } is sent" do
    ret = is_defined? { Object }
    ret.should == 'constant'
  end

  it "returns 'class variable' when @@x = 1; is_defined? { @@x } is sent" do
    @@x = 1
    ret = is_defined? { @@x }
    ret.should == 'class variable'
  end

  it "returns 'instance-variable' when @x = 1; is_defined? { @x } is sent" do
    @x = 1
    ret = is_defined? { @x }
    ret.should == 'instance-variable'
  end

  it "returns 'global-variable' when $x = 1; is_defined? { $x } is sent" do
    $x = 1
    ret = is_defined? { $x }
    ret.should == 'global-variable'
  end

  it "returns 'expression' when is_defined? { 'foo = bar' } is sent" do
    ret = is_defined? { 'foo = bar' }
    ret.should == "expression"
  end

  it "returns 'self' when is_defined? { self } is sent" do
    ret = is_defined? { self }
    ret.should == "self"
  end

  it "returns 'nil' when is_defined? { nil } is sent" do
    ret = is_defined? { nil }
    ret.should == "nil"
  end

  it "returns 'true' when is_defined? { true } is sent" do
    ret = is_defined? { true }
    ret.should == "true"
  end

  it "returns 'false' when is_defined? { false } is sent" do
    ret = is_defined? { false }
    ret.should == "false"
  end

  it "returns nil when is_defined? { no_such_local } is sent" do
    ret = is_defined? { no_such_local }
    ret.should == nil
  end

  it "returns 'expression' when is_defined? { :File } is sent" do
    ret = is_defined? { :File }
    ret.should == "expression"
  end

  it "returns 'constant' when is_defined? { LanguageDefinedSpecs::SomeConst } is sent" do
    ret = is_defined? { LanguageDefinedSpecs::SomeConst }
    ret.should == "constant"
  end

  it "returns 'constant' when evaluating self::FOO in module A" do
    ret = is_defined? { A::FOO }
    ret.should == 'constant'
  end

  it "returns 'constant' when is_defined? { File } is sent" do
    ret = is_defined? { File }
    ret.should == "constant"
  end

  it "returns 'constant' when is_defined? { File::SEPARATOR } is sent" do
    ret = is_defined? { File::SEPARATOR }
    ret.should == "constant"
  end

  it "returns 'method' when is_defined? { Object.nil? } is sent" do
    ret = is_defined? { Object.nil? }
    ret.should == "method"
  end

  it "returns 'expression' when is_defined? { 0 } is sent" do
    ret = is_defined? { 0 }
    ret.should == "expression"
  end

  # compliant_on :rubinius do
  #   # Rubinius does not care about dynamic vars
  #   it "returns 'local-variable' when defined? is called on a block var" do
  #     block = Proc.new { |x| is_defined? { x } }
  #     ret = block.call(1)
  #     ret.should == 'local-variable'
  #   end
  # end
  # 
  # # I (Evan) am not certain we'll support is_defined? { super } ever.
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
  #     block = Proc.new { |xxx| is_defined? { xxx } }
  #     ret = block.call(1)
  #     ret.should == 'local-variable(in-block)'
  #   end
  # 
  # end
end
