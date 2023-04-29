defmodule Lexicon.Token do
  @moduledoc """
  Lexicon token.
  """
  use Lexicon.Parser

  @type t :: %__MODULE__{
          type: :token,
          description: String.t() | nil
        }

  defstruct [:description, type: :token]
end
