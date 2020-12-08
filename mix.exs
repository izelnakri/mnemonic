defmodule Mnemonic.Mixfile do
  use Mix.Project

  @version "0.2.3"
  @source_url "https://github.com/izelnakri/mnemonic"

  def project do
    [
      app: :mnemonic,
      version: @version,
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

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.23.0", only: :dev, runtime: false},
    ]
  end

  defp description do
     """
     Elixir library for generating deterministic private keys from random words according to BIP39 standard.
     """
  end

  def package() do
    [
      name: :mnemonic,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Izel Nakri"],
      licenses: ["MIT License"],
      links: %{
        "Changelog" => "#{@source_url}/blob/master/CHANGELOG.md",
        "Docs" => "https://hexdocs.pm/mnemonic/Mnenomic.html",
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: [
        "README.md",
        "CHANGELOG.md"
      ]
    ]
  end
end
