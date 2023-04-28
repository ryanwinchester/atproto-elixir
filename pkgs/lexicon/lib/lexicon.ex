defmodule Lexicon do
  @moduledoc """
  Documentation for `Lexicon`.
  """

  alias Lexicon.Doc

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
