defmodule XRPCServerTest do
  use ExUnit.Case
  doctest XRPCServer

  test "greets the world" do
    assert XRPCServer.hello() == :world
  end
end
