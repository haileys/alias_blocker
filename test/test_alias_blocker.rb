require "test/unit"
require "alias_blocker"

class TestAliasBlocker < Test::Unit::TestCase
  def setup
    AliasBlocker.block!
  end

  def test_it_blocks_the_alias_keyword
    assert_raises AliasBlocker::AliasNotAllowed do
      alias a b
    end
  end

  def test_it_blocks_module_alias_method
    assert_raises AliasBlocker::AliasNotAllowed do
      Module.new do
        alias_method :a, :b
      end
    end
  end

  def test_it_lets_you_cheat
    c = Class.new do
      def abc; 123; end
    end
    refute c.instance_methods.include?(:xyz)
    AliasBlocker.cheat do
      c.class_eval do
        alias_method :xyz, :abc
      end
    end
    assert c.instance_methods.include?(:xyz)
    assert_equal 123, c.new.abc
  end

  def test_blocked?
    assert AliasBlocker.blocked?
    AliasBlocker.cheat do
      refute AliasBlocker.blocked?
    end
    assert AliasBlocker.blocked?
  end
end
