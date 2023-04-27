defmodule NSID.ValidatorTest do
  use ExUnit.Case, async: true

  alias NSID.Validator

  doctest Validator, import: true

  test "enforces spec details" do
    assert :ok = Validator.validate("com.example.foo")

    long_nsid = "com." <> String.duplicate("o", 63) <> ".foo"
    assert :ok = Validator.validate(long_nsid)

    too_long_nsid = "com." <> String.duplicate("o", 64) <> ".foo"
    assert {:error, _} = Validator.validate(too_long_nsid)

    long_end = "com.example." <> String.duplicate("o", 128)
    assert :ok = Validator.validate(long_end)

    too_long_end = "com.example." <> String.duplicate("o", 129)
    assert {:error, _} = Validator.validate(too_long_end)

    long_overall = "com." <> String.duplicate("middle.", 50) <> "foo"
    assert String.length(long_overall) == 357
    assert :ok = Validator.validate(long_overall)

    too_long_overall = "com." <> String.duplicate("middle.", 100) <> "foo"
    assert String.length(too_long_overall) == 707
    assert {:error, _} = Validator.validate(too_long_overall)

    assert :ok = Validator.validate("a.b.c")
    assert :ok = Validator.validate("a0.b1.c3")
    assert :ok = Validator.validate("a-0.b-1.c-3")
    assert :ok = Validator.validate("m.xn--masekowski-d0b.pl")
    assert :ok = Validator.validate("one.two.three")

    assert {:error, _} = Validator.validate("example.com")
    assert {:error, _} = Validator.validate("com.example")
    assert {:error, _} = Validator.validate("a.0.c")
    assert {:error, _} = Validator.validate("a.")
    assert {:error, _} = Validator.validate(".one.two.three")
    assert {:error, _} = Validator.validate("one.two.three ")
    assert {:error, _} = Validator.validate("one.two..three")
    assert {:error, _} = Validator.validate("one .two.three")
    assert {:error, _} = Validator.validate(" one.two.three")
    assert {:error, _} = Validator.validate("com.exa💩ple.thing")
    assert {:error, _} = Validator.validate("com.atproto.feed.p@st")
    assert {:error, _} = Validator.validate("com.atproto.feed.p_st")
    assert {:error, _} = Validator.validate("com.atproto.feed.p*st")
    assert {:error, _} = Validator.validate("com.atproto.feed.po#t")
    assert {:error, _} = Validator.validate("com.atproto.feed.p!ot")
    assert {:error, _} = Validator.validate("com.example-.foo")
  end

  test "allows onion (Tor) NSIDs" do
    assert :ok = Validator.validate("onion.expyuzz4wqqyqhjn.spec.getThing")

    assert :ok =
             Validator.validate(
               "onion.g2zyxa5ihm7nsggfxnu52rck2vv4rvmdlkiu3zzui5du4xyclen53wid.lex.deleteThing"
             )
  end

  test "blocks starting-with-numeric segments (differently from domains)" do
    assert {:error, _} = Validator.validate("org.4chan.lex.getThing")
    assert {:error, _} = Validator.validate("cn.8.lex.stuff")

    assert {:error, _} =
             Validator.validate(
               "onion.2gzyxa5ihm7nsggfxnu52rck2vv4rvmdlkiu3zzui5du4xyclen53wid.lex.deleteThing"
             )
  end
end
