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

  test "mnemonic_to_seed works" do
    @vectors |> Enum.each(fn(vector) ->
      target_entropy = List.first(vector)
      target_mnemonic = Enum.at(vector, 1)
      target_seed = Enum.at(vector, 2);

      assert Mnemonic.entropy_to_mnemonic(target_entropy) == target_mnemonic
      assert Mnemonic.mnemonic_to_entropy(target_mnemonic) |> String.downcase == target_entropy
      assert Mnemonic.mnemonic_to_seed(target_mnemonic, "TREZOR") == target_seed
      assert Mnemonic.validate_mnemonic(target_mnemonic)
      assert Mnemonic.validate_mnemonic(target_seed) == false
      assert Mnemonic.validate_seed(target_mnemonic, target_seed, "TREZOR")
      assert Mnemonic.validate_seed(target_mnemonic, target_seed, "") == false
    end)
  end

  # test "validate returns correct messages for invalid mnemonic phrases" do

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

  test "validate_mnemonic works correctly" do
    Mnemonic.validate_mnemonic("sleep kitten") == false
    Mnemonic.validate_mnemonic("sleep kitten sleep kitten sleep kitten") == false
    Mnemonic.validate_mnemonic("abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about end grace oxygen maze bright face loan ticket trial leg cruel lizard bread worry reject journey perfect chef section caught neither install industry") == false
    Mnemonic.validate_mnemonic("turtle front uncle idea crush write shrug there lottery flower risky shell") == false
    Mnemonic.validate_mnemonic("sleep kitten sleep kitten sleep kitten sleep kitten sleep kitten sleep kitten") == false
  end
end
