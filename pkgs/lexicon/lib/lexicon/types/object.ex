defmodule Lexicon.Object do
  @moduledoc """
  Lexicon object.
  """
  use Lexicon.Parser

  @type t :: %__MODULE__{
          type: :object,
          description: String.t() | nil,
          properties: %{
            required(String.t()) =>
              Lexicon.Ref.t() | Lexicon.Array.t() | Lexicon.Primitive.t() | [Lexicon.Ref.t()]
          },
          required: [String.t()],
          nullable: [String.t()]
        }

  defstruct [:description, :properties, required: [], nullable: [], type: :object]

  @impl Lexicon.Parser
  def parse_property({:properties, properties}) do
    primitives = ~w[boolean number integer string]

    properties =
      Enum.map(properties, fn
        {key, %{"type" => "ref"} = prop} -> {key, Lexicon.Ref.parse(prop)}
        {key, %{"type" => "array"} = prop} -> {key, Lexicon.Array.parse(prop)}
        {key, %{"type" => t} = prop} when t in primitives -> {key, Lexicon.Primitive.parse(prop)}
        {key, prop} when is_list(prop) -> {key, Enum.map(prop, &Lexicon.Ref.parse/1)}
      end)

    {:properties, properties}
  end

  def parse_property({:type, _type}), do: {:type, :object}
  def parse_property(property), do: property
end
