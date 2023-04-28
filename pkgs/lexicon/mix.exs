defmodule Lexicon.MixProject do
  use Mix.Project

  def project do
    [
      app: :lexicon,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(Mix.env()),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps(:prod) do
    [
      # External dependencies.
      {:cid, "~> 0.0.1"},
      {:ex_ipfs_ipld, "~> 0.0.1"},
      {:ex_multihash, "~> 2.0"},
      {:jason, "~> 1.4"},
      {:multicodec, "~> 0.0.2"},

      # Project dependencies.
      {:nsid, github: "ryanwinchester/atproto", sparse: "pkgs/nsid", only: [:prod]}
    ]
  end

  # Dev and test-specific dependencies and overrides.
  defp deps(env) when env in [:dev, :test] do
    deps_merge(deps(:prod), [
      # Project dependencies.
      {:nsid, path: "../nsid", only: [:dev, :test]},

      # Dev dependencies.
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false}
    ])
  end

  # Merge dependencies, preferring overrides.
  defp deps_merge(originals, overrides) do
    originals
    |> Enum.filter(&(List.keyfind(overrides, elem(&1, 0), 0) |> is_nil()))
    |> Enum.concat(overrides)
  end
end
