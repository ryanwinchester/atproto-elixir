defmodule Lexicon.Token do
  @moduledoc """
  Lexicon token.
  """

  @type t :: %__MODULE__{
          type: :token,
          description: String.t() | nil
        }

  defstruct [:description, type: :token]
end
