defmodule LexiconTest do
  use ExUnit.Case
  doctest Lexicon

  test "greets the world" do
    assert Lexicon.hello() == :world
  end
end
