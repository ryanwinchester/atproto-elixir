defmodule Lexicon.Doc do
  @moduledoc """
  A Lexicon document.
  See: https://atproto.com/specs/lexicon#interface
  """

  @type nsid :: String.t()

  @type t :: %__MODULE__{
          lexicon: 1,
          id: nsid(),
          revision: number() | nil,
          description: String.t() | nil,
          defs: %{
            required(String.t()) =>
              Lexicon.UserType.t() | Lexicon.Array.t() | Lexicon.Primitive.t() | [Lexicon.Ref.t()]
          }
        }

  @enforce_keys [:id, :defs]
  defstruct [:id, :revision, :description, :defs, lexicon: 1]

  @doc """
  Validate a Lexicon document.
  """
  @spec validate(t()) :: :ok | {:error, reason :: String.t()}
  def validate(%__MODULE__{id: nsid, defs: defs}) do
    with :ok <- NSID.validate(nsid) do
      validate_defs(defs)
    end
  end

  defp validate_defs(%{} = defs) do
    Enum.reduce_while(defs, :ok, fn
      {"main", %{type: type}}, :ok when type not in ~w[record procedure query subscription] ->
        {:halt, {:error, "Records, procedures, queries, and subscriptions must be the main def."}}

      {_def_id, %{type: _type}}, :ok ->
        {:cont, :ok}
    end)
  end
end
