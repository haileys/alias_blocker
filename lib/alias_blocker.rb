module AliasBlocker
  class AliasNotAllowed < StandardError
    def initialize(what = "The alias keyword")
      super "#{what} has been disabled. Please consider a cleaner way to do what you're trying to do. If you *really* need to use alias, you may use AliasBlocker.cheat."
    end
  end

  def self.block!
    @blocked = true
  end

  def self.blocked?
    !!@blocked
  end

  def self.cheat
    old_blocked = @blocked
    @blocked = false
    yield
  ensure
    @blocked = old_blocked
  end

  module FcoreExtension
    define_method :"core#set_method_alias" do |*args|
      raise AliasNotAllowed.new("The alias keyword") if AliasBlocker.blocked?
      super *args
    end

    fcore, = (-1024..1024)
      .each_with_object(RubyVM.object_id)
      .map { |offset, base| offset + base }
      .map { |ptr| ObjectSpace._id2ref ptr rescue nil }
      .grep(Class)
      .select { |klass| klass.instance_methods.include?(:"core#set_method_alias") }

    prepend_features fcore
  end

  module ModuleExtension
    def alias_method(*args)
      raise AliasNotAllowed.new("Module#alias_method") if AliasBlocker.blocked?
      super
    end

    prepend_features Module
  end
end
