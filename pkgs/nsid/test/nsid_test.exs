defmodule NSIDTest do
  use ExUnit.Case, async: true

  doctest NSID

  test "parses valid NSIDs" do
    assert %NSID{authority: "example.com", name: "foo"} = NSID.parse("com.example.foo")
    assert "com.example.foo" = NSID.parse("com.example.foo") |> to_string()

    assert %NSID{authority: "example.com", name: "*"} = NSID.parse("com.example.*")
    assert "com.example.*" = NSID.parse("com.example.*") |> to_string()

    assert %NSID{authority: "cool.long-thing1.com", name: "fooBarBaz"} =
             NSID.parse("com.long-thing1.cool.fooBarBaz")

    assert "com.long-thing1.cool.fooBarBaz" =
             NSID.parse("com.long-thing1.cool.fooBarBaz") |> to_string()
  end

  test "creates valid NSIDs" do
    assert {:ok, %NSID{authority: "example.com", name: "foo"}} = NSID.new("example.com", "foo")
    assert %NSID{authority: "example.com", name: "foo"} = NSID.new!("example.com", "foo")
    assert "com.example.foo" = NSID.new!("example.com", "foo") |> to_string()

    assert {:ok, %NSID{authority: "example.com", name: "*"}} = NSID.new("example.com", "*")
    assert %NSID{authority: "example.com", name: "*"} = NSID.new!("example.com", "*")
    assert "com.example.*" = NSID.new!("example.com", "*") |> to_string()

    assert {:ok, %NSID{authority: "cool.long-thing1.com", name: "fooBarBaz"}} =
             NSID.new("cool.long-thing1.com", "fooBarBaz")

    assert %NSID{authority: "cool.long-thing1.com", name: "fooBarBaz"} =
             NSID.new!("cool.long-thing1.com", "fooBarBaz")

    assert "com.long-thing1.cool.fooBarBaz" =
             NSID.new!("cool.long-thing1.com", "fooBarBaz") |> to_string()
  end
end
