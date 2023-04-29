defmodule Lexicon.Video do
  @moduledoc """
  Lexicon video.
  """
  use Lexicon.Parser

  @type t :: %__MODULE__{
          type: :video,
          description: String.t() | nil,
          max_size: non_neg_integer() | nil,
          max_width: non_neg_integer() | nil,
          max_height: non_neg_integer() | nil,
          max_length: non_neg_integer() | nil,
          accept: [String.t()]
        }

  defstruct [
    :description,
    :max_size,
    :max_width,
    :max_height,
    :max_length,
    accept: [],
    type: :video
  ]
end
