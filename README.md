# alias_blocker

I'm not a fan of the `alias` keyword. `Module#alias_method` is slightly better (because it isn't special cased syntax), but it still strikes me as a dirty way to go about things.

This gem blocks `alias` and `Module#alias_method`, forcing programmers to carefully consider their usage of these features.

## Usage

Using alias_blocker is simple:

```ruby
AliasBlocker.block!

alias a b # raises AliasBlocker::AliasNotAllowed
```

You can also temporarily unblock alias if you really need to:

```ruby
AliasBlocker.cheat do
  alias a b # this works
end
```

## License

WTFPL
