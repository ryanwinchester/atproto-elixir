defmodule Lexicon.RefUnion do
  @moduledoc """
  Lexicon ref union.
  """
  use Lexicon.Parser

  @type t :: %__MODULE__{
          type: :union,
          description: String.t() | nil,
          closed: boolean() | nil,
          refs: [String.t()]
        }

  @enforce_keys [:refs]
  defstruct [:description, :closed, :refs, type: :union]
end
