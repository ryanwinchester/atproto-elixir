defmodule NSID.Validator do
  @moduledoc """
  Validates NSIDs and its parts.
  """

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
    with nsid_parts = String.split(nsid, "."),
         :ok <- validate_ascii(nsid),
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

  def regex_validate(nsid) when is_binary(nsid) and byte_size(nsid) > 253 + 1 + 128 do
    {:error, "NSID is too long (382 chars max)"}
  end

  def regex_validate(nsid) when is_binary(nsid) do
    if Regex.match?(~r/^[a-zA-Z]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+(\.[a-zA-Z]([a-zA-Z0-9-]{0,126}[a-zA-Z0-9])?)$/, nsid) do
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

  defp validate_length(nsid_str) do
    if byte_size(nsid_str) <= 253 + 1 + 128 do
      :ok
    else
      {:error, "NSID is too long (382 chars max)"}
    end
  end

  defp validate_parts(nsid_parts) do
    with {name, authority_parts} = List.pop_at(nsid_parts, -1),
         :ok <- validate_parts_count(nsid_parts),
         :ok <- validate_name(name),
         :ok <- validate_domain_parts(authority_parts) do
      :ok
    end
  end

  defp validate_parts_count([_one, _two, _three | _]), do: :ok

  defp validate_parts_count(_) do
    {:error, "NSID authority must contain at least three parts"}
  end

  defp validate_name("*"), do: :ok

  defp validate_name(name) do
    with :ok <- validate_name_part_length(name),
         :ok <- validate_not_ends_with_dash(name),
         :ok <- validate_starts_with_ascii_letter(name) do
      :ok
    end
  end

  defp validate_domain_parts(domain_parts) do
    Enum.reduce_while(domain_parts, :ok, fn part, _acc ->
      case validate_domain_part(part) do
        :ok ->
          {:cont, :ok}

        {:error, reason} ->
          {:halt, {:error, reason}}
      end
    end)
  end

  defp validate_domain_part(part) do
    with :ok <- validate_domain_part_length(part),
         :ok <- validate_not_ends_with_dash(part),
         :ok <- validate_starts_with_ascii_letter(part) do
      :ok
    end
  end

  defp validate_domain_part_length(""), do: {:error, "NSID parts can not be empty"}

  defp validate_domain_part_length(part) when byte_size(part) > 63,
    do: {:error, "NSID domain part too long (max 63 chars)"}

  defp validate_domain_part_length(_), do: :ok

  defp validate_name_part_length(""), do: {:error, "NSID parts can not be empty"}

  defp validate_name_part_length(part) when byte_size(part) > 127,
    do: {:error, "NSID name part too long (max 127 chars)"}

  defp validate_name_part_length(_part), do: :ok

  defp validate_starts_with_ascii_letter(<<c, _rest::binary>>) when c in ?a..?z or c in ?A..?Z,
    do: :ok

  defp validate_starts_with_ascii_letter(_part),
    do: {:error, "NSID parts must start with ASCII letter"}

  defp validate_not_ends_with_dash(part) do
    if String.ends_with?(part, "-") do
      {:error, "NSID parts can not end with a dash"}
    else
      :ok
    end
  end
end
