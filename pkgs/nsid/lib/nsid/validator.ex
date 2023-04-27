defmodule NSID.Validator do
  @moduledoc """
  Validates NSIDs and its parts.

  Covers the same validations as [bluesky-social/atproto/nsid].

  [bluesky-social/atproto/nsid]: https://github.com/bluesky-social/atproto/blob/main/packages/nsid/src/index.ts
  """

  @max_domain_length 253
  @max_label_length 63
  @max_name_length 128

  @max_nsid_length @max_domain_length + 1 + @max_name_length

  @doc """
  Validate an NSID.

  ## Examples

    iex> validate("com.example.thing")
    :ok

    iex> validate("net.users")
    {:error, "NSID authority must contain at least three parts"}

  """
  @spec validate(NSID.t() | String.t()) :: :ok | {:error, reason :: String.t()}
  def validate(%NSID{} = nsid) do
    nsid
    |> NSID.to_string()
    |> validate()
  end

  def validate(nsid) when is_binary(nsid) do
    nsid_parts = String.split(nsid, ".")

    with :ok <- validate_ascii(nsid),
         :ok <- validate_length(nsid),
         :ok <- validate_parts(nsid_parts) do
      :ok
    end
  end

  @doc """
  Simple regex to enforce most constraints via just regex and length.
  *Note: `nsid-ns` is not handled in regex yet.*

  ## Examples

    iex> regex_validate("com.example.thing")
    :ok

    iex> regex_validate("net.users")
    {:error, "NSID didn't validate via regex"}

  """
  @spec regex_validate(NSID.t() | String.t()) :: :ok | {:error, reason :: String.t()}
  def regex_validate(%NSID{} = nsid) do
    nsid
    |> NSID.to_string()
    |> regex_validate()
  end

  def regex_validate(nsid) when is_binary(nsid) and byte_size(nsid) > @max_nsid_length do
    {:error, "NSID is too long (382 chars max)"}
  end

  def regex_validate(nsid) when is_binary(nsid) do
    if Regex.match?(
         ~r/^[a-zA-Z]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+(\.[a-zA-Z]([a-zA-Z0-9-]{0,126}[a-zA-Z0-9])?)$/,
         nsid
       ) do
      :ok
    else
      {:error, "NSID didn't validate via regex"}
    end
  end

  # ----------------------------------------------------------------------------
  # Validators
  # ----------------------------------------------------------------------------

  defp validate_ascii(nsid_str) do
    if Regex.match?(~r/^[a-zA-Z0-9.-]*(\.\*)?$/, nsid_str) do
      :ok
    else
      {:error, "Disallowed characters in NSID (ASCII letters, digits, dashes, periods only)"}
    end
  end

  defp validate_length(nsid) when byte_size(nsid) > @max_nsid_length,
    do: {:error, "NSID is too long (382 chars max)"}

  defp validate_length(_), do: :ok

  ## Parts.

  defp validate_parts(nsid_parts) do
    {name, domain_labels} = List.pop_at(nsid_parts, -1)

    with :ok <- validate_parts_count(nsid_parts),
         :ok <- validate_name(name),
         :ok <- validate_labels(domain_labels) do
      :ok
    end
  end

  defp validate_parts_count([_one, _two, _three | _]), do: :ok
  defp validate_parts_count(_), do: {:error, "NSID authority must contain at least three parts"}

  ## Name.

  defp validate_name("*"), do: :ok

  defp validate_name(name) do
    with :ok <- validate_name_length(name),
         :ok <- validate_not_ends_with_dash(name),
         :ok <- validate_starts_with_ascii_letter(name) do
      :ok
    end
  end

  ## Labels.

  defp validate_labels(domain_labels) do
    Enum.reduce_while(domain_labels, :ok, fn label, _acc ->
      case validate_label(label) do
        :ok ->
          {:cont, :ok}

        {:error, reason} ->
          {:halt, {:error, reason}}
      end
    end)
  end

  defp validate_label(label) do
    with :ok <- validate_label_length(label),
         :ok <- validate_not_ends_with_dash(label),
         :ok <- validate_starts_with_ascii_letter(label) do
      :ok
    end
  end

  ## Label length.

  defp validate_label_length(""), do: {:error, "NSID parts can not be empty"}

  defp validate_label_length(label) when byte_size(label) > @max_label_length,
    do: {:error, "NSID domain part too long (max 63 chars)"}

  defp validate_label_length(_), do: :ok

  ## Name length.

  defp validate_name_length(""), do: {:error, "NSID parts can not be empty"}

  defp validate_name_length(name) when byte_size(name) > @max_name_length,
    do: {:error, "NSID name part too long (max 128 chars)"}

  defp validate_name_length(_name), do: :ok

  ## Starts with ASCII letter.

  defp validate_starts_with_ascii_letter(<<c, _rest::binary>>) when c in ?a..?z or c in ?A..?Z,
    do: :ok

  defp validate_starts_with_ascii_letter(_part),
    do: {:error, "NSID parts must start with ASCII letter"}

  ## Does not end with dash.

  defp validate_not_ends_with_dash(part) do
    if String.ends_with?(part, "-") do
      {:error, "NSID parts can not end with a dash"}
    else
      :ok
    end
  end
end
