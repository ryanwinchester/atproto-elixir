defmodule Lexicon.Primitive do
  @moduledoc """
  Lexicon primitive.
  """
  use Lexicon.Parser

  @type t :: %__MODULE__{
          type: :boolean | :number | :integer | :string,
          description: String.t() | nil
        }

  @enforce_keys [:type]
  defstruct [:description, :type]
end
