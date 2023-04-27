defmodule XRPCTest do
  use ExUnit.Case
  doctest XRPC

  test "greets the world" do
    assert XRPC.hello() == :world
  end
end
