defmodule Lexicon.Record do
  @moduledoc """
  Lexicon record.
  """
  use Lexicon.Parser,
    children: [
      record: Lexicon.Object
    ]

  @type t :: %__MODULE__{
          type: :record,
          description: String.t() | nil,
          key: String.t() | nil,
          record: Lexicon.Object.t()
        }

  @enforce_keys [:record]
  defstruct [:description, :key, :record, type: :record]
end
