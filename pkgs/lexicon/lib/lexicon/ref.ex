defmodule Lexicon.Ref do
  @moduledoc """
  Lexicon ref.
  """

  @type t :: %__MODULE__{
          type: :ref,
          description: String.t() | nil,
          ref: String.t()
        }

  @enforce_keys [:ref]
  defstruct [:description, :ref, type: :ref]
end
