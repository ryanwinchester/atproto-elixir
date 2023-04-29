defmodule Lexicon.XRPC.Query do
  @moduledoc """
  Lexicon XRPC query.
  """
  use Lexicon.Parser,
    children: [
      output: Lexicon.XRPC.Body
    ]

  @type t :: %__MODULE__{
          type: :query,
          description: String.t() | nil,
          output: Lexicon.XRPC.Body.t(),
          parameters: %{optional(String.t()) => Lexicon.Primitive.t()},
          errors: [Lexicon.XRPC.Error.t()]
        }

  defstruct [:description, :output, parameters: %{}, errors: [], type: :query]

  @impl Lexicon.Parser
  def parse_property({:parameters, params}) do
    params =
      Enum.map(params, fn {key, primitive} ->
        {key, Lexicon.Primitive.parse(primitive)}
      end)

    {:parameters, params}
  end

  def parse_property({:errors, errors}) do
    {:errors, Enum.map(errors, &Lexicon.XRPC.Error.parse/1)}
  end

  def parse_property({:type, _type}), do: {:type, :query}
  def parse_property(property), do: property
end
