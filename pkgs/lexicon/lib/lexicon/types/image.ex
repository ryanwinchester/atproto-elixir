defmodule Lexicon.Image do
  @moduledoc """
  Lexicon image.
  """

  @type t :: %__MODULE__{
          type: :image,
          description: String.t() | nil,
          accept: [String.t()],
          max_size: pos_integer() | nil,
          max_width: pos_integer() | nil,
          max_height: pos_integer() | nil
        }

  defstruct [:description, :max_size, :max_width, :max_height, accept: [], type: :image]
end
