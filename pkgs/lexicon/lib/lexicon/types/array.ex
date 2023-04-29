defmodule Lexicon.Array do
  @moduledoc """
  Lexicon array.
  """

  @type t :: %__MODULE__{
          type: :array,
          description: String.t() | nil,
          items: Lexicon.Ref.t() | Lexicon.Primitive.t() | [Lexicon.Ref.t()],
          min_length: non_neg_integer() | nil,
          max_length: non_neg_integer() | nil
        }

  @enforce_keys [:items]
  defstruct [:description, :items, :min_length, :max_length, type: :array]
end
