defmodule Lexicon.Array do
  @moduledoc """
  Lexicon array.
  """
  use Lexicon.Parser

  @type t :: %__MODULE__{
          type: :array,
          description: String.t() | nil,
          items: Lexicon.Ref.t() | Lexicon.Primitive.t() | [Lexicon.Ref.t()],
          min_length: non_neg_integer() | nil,
          max_length: non_neg_integer() | nil
        }

  @enforce_keys [:items]
  defstruct [:description, :items, :min_length, :max_length, type: :array]

  @primitives ~w[boolean number integer string]

  @impl Lexicon.Parser
  def parse_property({:items, items}) do
    items =
      case items do
        %{"type" => "ref"} -> Lexicon.Ref.parse(items)
        %{"type" => type} when type in @primitives -> Lexicon.Primitive.parse(items)
        items when is_list(items) -> Enum.map(items, &Lexicon.Ref.parse/1)
      end

    {:items, items}
  end

  def parse_property({:type, _type}), do: {:type, :array}
  def parse_property(property), do: property
end
