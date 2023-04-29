defmodule Lexicon.XRPC.Error do
  @moduledoc """
  Lexicon XRPC error.
  """
  use Lexicon.Parser

  @type t :: %__MODULE__{
          description: String.t() | nil,
          name: String.t()
        }

  @enforce_keys [:name]
  defstruct [:description, :name]
end
