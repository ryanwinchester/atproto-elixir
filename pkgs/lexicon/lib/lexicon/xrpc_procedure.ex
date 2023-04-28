defmodule Lexicon.XRPC.Procedure do
  @moduledoc """
  Lexicon XRPC procedure.
  """

  @type t :: %__MODULE__{
          type: :procedure,
          description: String.t() | nil,
          input: Lexicon.XRPC.Body.t() | nil,
          output: Lexicon.XRPC.Body.t() | nil,
          parameters: %{optional(String.t()) => Lexicon.Primitive.t()},
          errors: [Lexicon.XRPC.Error.t()]
        }

  defstruct [:description, :input, :output, parameters: %{}, errors: [], type: :procedure]
end
