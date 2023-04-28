defmodule Lexicon.Audio do
  @moduledoc """
  Lexicon audio.
  """

  @type t :: %__MODULE__{
          type: :audio,
          description: String.t() | nil,
          max_size: non_neg_integer() | nil,
          max_length: non_neg_integer() | nil,
          accept: [String.t()]
        }

  defstruct [:description, :max_size, :max_length, accept: [], type: :audio]
end
