defmodule Lexicon.UserType do
  @moduledoc """
  A Lexicon user type.
  """
  use Lexicon.Parser

  @type t :: %__MODULE__{
          description: String.t() | nil,
          type:
            :query
            | :procedure
            | :record
            | :token
            | :object
            | :blob
            | :image
            | :video
            | :audio
        }

  @enforce_keys [:type]
  defstruct [:type, :description]
end
