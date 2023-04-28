defmodule Lexicon do
  @moduledoc """
  Documentation for `Lexicon`.
  """

  alias Lexicon.Doc

  def to_ipld(lexicon_values) when is_list(lexicon_values) do
    Enum.map(lexicon_values, &to_ipld/1)
  end

  def to_ipld(_lexicon_value) do
    # cond do
    #   CID.cid?(lexicon_value) -> lexicon_value
    #   true -> lexicon_value
    # end
  end

  @doc """
  Add a lexicon doc.

  ## Examples

      iex> Lexicon.add(doc)
      :ok

  """
  def add(%Doc{} = _doc) do
    # Elixir version
    # doc = Doc.parse(doc)

    # TS version
    # try {
    #   lexiconDoc.parse(doc)
    # } catch (e) {
    #   if (e instanceof ZodError) {
    #     throw new LexiconDocMalformedError(
    #       `Failed to parse schema definition ${
    #         (doc as Record<string, string>).id
    #       }`,
    #       doc,
    #       e.issues,
    #     )
    #   } else {
    #     throw e
    #   }
    # }
    # const validatedDoc = doc as LexiconDoc
    # const uri = toLexUri(validatedDoc.id)
    # if (this.docs.has(uri)) {
    #   throw new Error(`${uri} has already been registered`)
    # }

    # // WARNING
    # // mutates the object
    # // -prf
    # resolveRefUris(validatedDoc, uri)

    # this.docs.set(uri, validatedDoc)
    # for (const [defUri, def] of iterDefs(validatedDoc)) {
    #   this.defs.set(defUri, def)
    # }
  end
end
