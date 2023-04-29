defmodule Lexicon.Doc do
  @moduledoc """
  A Lexicon document.
  See: https://atproto.com/specs/lexicon#interface
  """

  @behaviour Lexicon.Parser

  alias __MODULE__

  @type nsid :: String.t()

  @type t :: %__MODULE__{
          lexicon: 1,
          id: nsid(),
          # TODO: Need to confirm if revision is meant to be an integer or not.
          revision: number() | nil,
          description: String.t() | nil,
          defs: %{
            required(String.t()) =>
              Lexicon.UserType.t() | Lexicon.Array.t() | Lexicon.Primitive.t() | [Lexicon.Ref.t()]
          }
        }

  @enforce_keys [:id, :defs]
  defstruct [:id, :revision, :description, :defs, lexicon: 1]

  @user_types %{
    "array" => Lexicon.Array,
    "blob" => Lexicon.Blob,
    "boolean" => Lexicon.Boolean,
    "bytes" => Lexicon.Bytes,
    "cid-link" => Lexicon.CIDLink,
    "integer" => Lexicon.Integer,
    "object" => Lexicon.Object,
    "procedure" => Lexicon.XRPC.Procedure,
    "query" => Lexicon.XRPC.Query,
    "record" => Lexicon.Record,
    "string" => Lexicon.String,
    "subscription" => Lexicon.Subscription,
    "token" => Lexicon.Token,
    "unknown" => Lexicon.Unknown
  }

  # Where `defs` is a map where the key is a `def_id` (e.g. "main") and the
  # value is a `Lexicon.UserType`.
  @impl Lexicon.Parser
  def parse_property({:defs, defs}) do
    defs =
      Enum.into(defs, %{}, fn {def_id, %{"type" => type} = def} ->
        {def_id, apply(@user_types[type], :parse, [def])}
      end)

    {:defs, defs}
  end

  def parse_property(property), do: property

  @doc """
  Validate a Lexicon document.
  """
  @spec validate(t()) :: :ok | {:error, reason :: String.t()}
  def validate(%Doc{id: nsid, defs: defs}) do
    with :ok <- NSID.validate(nsid) do
      validate_defs(defs)
    end
  end

  defp validate_defs(%{} = defs) do
    Enum.reduce_while(defs, :ok, fn
      {"main", %{type: type}}, :ok when type not in ~w[record procedure query subscription] ->
        {:halt,
         {:error, "Records, procedures, queries, and subscriptions must be the main definition."}}

      {_def_id, %{type: _type}}, :ok ->
        {:cont, :ok}
    end)
  end
end
