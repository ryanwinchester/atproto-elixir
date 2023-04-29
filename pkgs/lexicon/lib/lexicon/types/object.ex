defmodule Lexicon.Object do
  @moduledoc """
  Lexicon object.
  """

  @type t :: %__MODULE__{
          type: :object,
          description: String.t() | nil,
          properties: %{
            required(String.t()) =>
              Lexicon.Ref.t() | Lexicon.Array.t() | Lexicon.Primitive.t() | [Lexicon.Ref.t()]
          },
          required: [String.t()],
          nullable: [String.t()]
        }

  defstruct [:description, :properties, required: [], nullable: [], type: :object]
end
