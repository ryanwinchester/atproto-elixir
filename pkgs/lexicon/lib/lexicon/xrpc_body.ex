defmodule Lexicon.XRPC.Body do
  @moduledoc """
  Lexicon XRPC body.
  """

  @type t :: %__MODULE__{
          description: String.t() | nil,
          encoding: String.t() | [String.t()],
          schema: Lexicon.Ref.t() | Lexicon.RefUnion.t() | Lexicon.Object.t()
        }

  @enforce_keys [:description, :encoding, :schema]
  defstruct [:description, :encoding, :schema]
end
