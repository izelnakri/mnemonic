defmodule Mnemonic.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mnemonic,
      version: "0.2.2",
      elixir: "~> 1.10",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      description: description()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
     """
     Elixir library for generating deterministic private keys from random words according to BIP39 standard.
     """
  end

  def package do
    [
      name: :mnemonic,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Izel Nakri"],
      licenses: ["MIT License"],
      links: %{
        "GitHub" => "https://github.com/izelnakri/mnemonic",
        "Docs" => "https://hexdocs.pm/mnemonic/Mnemonic.html"
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
