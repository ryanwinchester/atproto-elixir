defmodule Lexicon.XRPC.Body do
  @moduledoc """
  Lexicon XRPC body.
  """
  use Lexicon.Parser

  @type t :: %__MODULE__{
          description: String.t() | nil,
          encoding: String.t() | [String.t()],
          schema: Lexicon.Ref.t() | Lexicon.RefUnion.t() | Lexicon.Object.t()
        }

  @enforce_keys [:description, :encoding, :schema]
  defstruct [:description, :encoding, :schema]

  @impl Lexicon.Parser
  def parse_property({:schema, schema}) do
    schema =
      case schema do
        %{"type" => "ref"} -> Lexicon.Ref.parse(schema)
        %{"type" => "union"} -> Lexicon.RefUnion.parse(schema)
        %{"type" => "object"} -> Lexicon.Object.parse(schema)
      end

    {:schema, schema}
  end

  def parse_property(property), do: property
end
