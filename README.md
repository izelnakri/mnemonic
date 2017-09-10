# Mnemonic

Elixir library for generating deterministic private keys from random words:

```elixir
  Mnemonic.generate()
  # "obscure appear begin host burden uncle glow tell journey autumn burden welcome"
  words = Mnemonic.generate()
  # "pretty element obey slab way middle brisk glory stone material hungry guess"
  key = Mnemonic.mnemonic_to_entropy(words)
  # AA28F65FE57F811887131CD6511DBD33

  mnemonic = Mnemonic.entropy_to_mnemonic("00000000000000000000000000000000")
  # "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
  Mnemonic.mnemonic_to_entropy(mnemonic)
  # "00000000000000000000000000000000"
```

TODO:
- add tests
- add examples
- add documentation
- maybe do mnemonic to seed

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mnemonic` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mnemonic, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/mnemonic](https://hexdocs.pm/mnemonic).
