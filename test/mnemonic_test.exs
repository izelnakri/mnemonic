defmodule MnemonicTest do
  use ExUnit.Case
  # doctest Mnemonic
  @vectors Fixtures.Vectors.all() |> Map.get(:english)

  test "vectors example word for the library" do
    @vectors |> Enum.each(fn(vector) ->
      target_entropy = List.first(vector)
      target_mnemonic = Enum.at(vector, 1)

      assert Mnemonic.entropy_to_mnemonic(target_entropy) == target_mnemonic
      assert Mnemonic.mnemonic_to_entropy(target_mnemonic) |> String.downcase == target_entropy
    end)
  end

  # test "validate returns correct messages for invalid mnemonic phrases" do
  #
  # end

  test "entropy_to_mnemonic works" do
    entropy = "00000000000000000000000000000000"
    mnemonic = Mnemonic.entropy_to_mnemonic(entropy)
    assert mnemonic == "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
    assert Mnemonic.mnemonic_to_entropy(mnemonic) == entropy
  end

  test "can create and recover mnemonic private keys" do
    1..10000 |> Enum.reduce([], fn(x, acc) ->
      mnemonic = Mnemonic.generate()
      IO.puts(mnemonic)
      if Enum.member?(acc, mnemonic) do
        raise "Duplicate mnemonic found #{mnemonic}"
      end

      private_key = Mnemonic.mnemonic_to_entropy(mnemonic)
      assert Mnemonic.entropy_to_mnemonic(private_key) == mnemonic

      [mnemonic | acc]
    end)
  end

  # also test that word count is 2048 bits(?)
end
#
# [1, 2, 3, 4, 5, 1, 6, 7] |> Enum.reduce([], fn(x, acc) ->
#   if Enum.member?(acc, x) do
#     raise "Duplicate value found #{x}"
#   end
#
#   [x | acc]
# end)
