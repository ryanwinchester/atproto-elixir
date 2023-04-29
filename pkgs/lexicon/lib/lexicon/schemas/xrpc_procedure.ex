defmodule Lexicon.XRPC.Procedure do
  @moduledoc """
  Lexicon XRPC procedure.
  """
  use Lexicon.Parser,
    children: [
      input: Lexicon.XRPC.Body,
      output: Lexicon.XRPC.Body
    ]

  @type t :: %__MODULE__{
          type: :procedure,
          description: String.t() | nil,
          input: Lexicon.XRPC.Body.t() | nil,
          output: Lexicon.XRPC.Body.t() | nil,
          parameters: %{optional(String.t()) => Lexicon.Primitive.t()},
          errors: [Lexicon.XRPC.Error.t()]
        }

  defstruct [:description, :input, :output, parameters: %{}, errors: [], type: :procedure]

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

  def parse_property({:type, _type}), do: {:type, :procedure}
  def parse_property(property), do: property
end
