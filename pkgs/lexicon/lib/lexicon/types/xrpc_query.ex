defmodule Lexicon.XRPC.Query do
  @moduledoc """
  Lexicon XRPC query.
  """

  @type t :: %__MODULE__{
          type: :query,
          description: String.t() | nil,
          output: Lexicon.XRPC.Body.t(),
          parameters: %{optional(String.t()) => Lexicon.Primitive.t()},
          errors: [Lexicon.XRPC.Error.t()]
        }

  defstruct [:description, :output, parameters: %{}, errors: [], type: :query]
end
