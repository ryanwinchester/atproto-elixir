defmodule Lexicon.Ref do
  @moduledoc """
  Lexicon ref.
  """
  use Lexicon.Parser

  @type t :: %__MODULE__{
          type: :ref,
          description: String.t() | nil,
          ref: String.t()
        }

  @enforce_keys [:ref]
  defstruct [:description, :ref, type: :ref]
end
