defmodule Lexicon.Parser do
  @moduledoc """
  Behaviour for Lexicon parsers.
  """

  @doc """
  Parse JSON into a Lexicon struct.
  """
  @callback parse(map() | String.t()) :: struct()

  @doc """
  Parse a property of a Lexicon struct as a key-value pair.
  """
  @callback parse_property({key :: atom(), value :: any()}) :: {key :: atom(), value :: any()}

  # In the future we should probably implement them explicitly in each module,
  # which would allow us to directly return a struct instead of iterating over
  # properties of each Lexicon struct and it's children. It would be a slight
  # performance improvement, and it would also make the code more explicit.
  # It would just take longer to write, and I'm doing this on my own at the moment.
  @doc false
  defmacro __using__(opts) do
    children = Keyword.get(opts, :children, [])

    quote do
      @behaviour Lexicon.Parser

      @impl Lexicon.Parser
      def parse(obj), do: default_parse(__MODULE__, obj, unquote(children))

      @impl Lexicon.Parser
      def parse_property(property), do: default_parse_property(__MODULE__, property)

      defoverridable parse: 1, parse_property: 1
    end
  end

  @doc """
  The default implementation of `c:parse/1`.
  """
  @spec default_parse(module(), map() | String.t(), keyword()) :: struct()
  def default_parse(_module, %__MODULE__{} = obj, _children), do: obj

  def default_parse(module, obj, children) when is_binary(obj) do
    default_parse(module, Jason.decode!(obj, keys: :atoms!), children)
  end

  def default_parse(module, %{"type" => _type} = obj, children) do
    obj
    |> Enum.into(%{}, fn {key, value} -> {String.to_existing_atom(key), value} end)
    |> then(&default_parse(module, &1, children))
  end

  def default_parse(module, %{type: _type} = obj, children) do
    children
    |> Enum.reduce(obj, fn {child, parser}, obj -> Map.update!(obj, child, &parser.parse/1) end)
    |> Enum.map(&module.parse_property/1)
    |> then(&struct(__MODULE__, &1))
  end

  @doc """
  The default implementation of `c:parse_property/1`.
  """
  @spec default_parse_property(module(), {atom(), any()}) :: {atom(), any()}
  def default_parse_property(_module, {:type, type}) when is_binary(type) do
    {key, String.to_existing_atom(type)}
  end

  def default_parse_property(_module, preoperty), do: preoperty
end
