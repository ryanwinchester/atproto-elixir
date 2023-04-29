defmodule Lexicon.Blob do
  @moduledoc """
  Lexicon blob.
  """
  use Lexicon.Parser

  @type t :: %__MODULE__{
          type: :blob,
          description: String.t() | nil,
          max_size: non_neg_integer() | nil,
          accept: [String.t()]
        }

  defstruct [:description, :max_size, accept: [], type: :blob]
end
