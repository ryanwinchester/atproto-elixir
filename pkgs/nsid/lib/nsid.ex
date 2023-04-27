defmodule NSID do
  @moduledoc """
  NameSpaced IDs (NSIDs) are used throughout ATP to identify methods, records
  types, and othersemantic information.

  NSIDs use [Reverse Domain-Name Notation] with the additional constraint that
  the segments prior to the final segment *must* map to a valid domain name.
  For instance, the owner of `example.com` could use the ID of
  `com.example.foo` but could not use `com.example.foo.bar` unless they also
  control `foo.example.com`. These rules are to ensure that schemas are
  globally unique, have a clear authority mapping (to a registered domain), and
  can potentially be resolved by request.

  Some example NSIDs:

      com.example.status
      io.social.getFeed
      net.users.bob.ping

  See [NSID docs] for more information.

  [Reverse Domain-Name Notation]: https://en.wikipedia.org/wiki/Reverse_domain_name_notation
  [NSID docs]: https://atproto.com/specs/nsid
  """

  @type t :: %NSID{
          authority: String.t(),
          name: String.t()
        }

  @enforce_keys [:authority, :name]
  defstruct [:authority, :name]

  @doc """
  Create a new, valid NSID.

  ## Example

      iex> NSID.new("example.com", "thing")
      {:ok, %NSID{authority: "example.com", name: "thing"}}

      iex> NSID.new("example.com", "-thing")
      {:error, "NSID parts must start with ASCII letter"}

  """
  @spec new(String.t(), String.t()) :: {:ok, t()} | {:error, reason :: String.t()}
  def new(authority, name) do
    nsid = %NSID{authority: authority, name: name}

    with :ok <- validate(nsid) do
      {:ok, nsid}
    end
  end

  @doc """
  Create a new, valid NSID.

  Raises an `ArgumentError` if the NSID is invalid.

  ## Example

      iex> NSID.new!("example.com", "thing")
      %NSID{authority: "example.com", name: "thing"}

  """
  @spec new!(String.t(), String.t()) :: t()
  def new!(authority, name) do
    case new(authority, name) do
      {:ok, nsid} ->
        nsid

      {:error, reason} ->
        raise ArgumentError, reason
    end
  end

  @doc """
  Parses an NSID string into its componenets, without further validation.

  ## Examples

      iex> NSID.parse("com.example.thing")
      %NSID{authority: "example.com", name: "thing"}

      iex> NSID.parse("net.users.bob.ping")
      %NSID{authority: "bob.users.net", name: "ping"}

      iex> NSID.parse(%NSID{authority: "example.com", name: "thing"})
      %NSID{authority: "example.com", name: "thing"}

  """
  @spec parse(String.t() | t()) :: t()
  def parse(%NSID{} = nsid), do: nsid

  def parse(nsid_str) when is_binary(nsid_str) do
    {name, authority_segments} =
      nsid_str
      |> String.split(".")
      |> List.pop_at(-1)

    authority =
      authority_segments
      |> Enum.reverse()
      |> Enum.join(".")

    %NSID{authority: authority, name: name}
  end

  @doc """
  Returns the string representation of the given [NSID struct](`t:t/0`).

  ## Examples

      iex> NSID.to_string(%NSID{authority: "example.com", name: "thing"})
      "com.example.thing"

      iex> NSID.to_string(%NSID{authority: "bob.users.net", name: "ping"})
      "net.users.bob.ping"

  """
  @spec to_string(t()) :: String.t()
  defdelegate to_string(nsid), to: String.Chars.NSID

  @doc """
  Validate an NSID.

  ## Examples

      iex> NSID.validate("com.example.thing")
      :ok

      iex> NSID.validate("net.users")
      {:error, "NSID authority must contain at least three parts"}

  """
  @spec validate(t() | String.t()) :: :ok | {:error, reason :: String.t()}
  defdelegate validate(nsid), to: NSID.Validator
end

defimpl String.Chars, for: NSID do
  def to_string(%NSID{authority: authority, name: name}) do
    "#{reverse_authority(authority)}.#{name}"
  end

  defp reverse_authority(authority) do
    authority
    |> String.split(".")
    |> Enum.reverse()
    |> Enum.join(".")
  end
end
