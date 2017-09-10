defmodule MnemonicTest do
  use ExUnit.Case
  # doctest Mnemonic

  # test "can create and recover mnemonic private keys" do
  #
  # end

  # test "validate returns correct messages for invalid mnemonic phrases" do
  #   assert Mnemonic.hello() == :world
  # end

  test "entropy_to_mnemonic works" do
    entropy = "00000000000000000000000000000000"
    mnemonic = Mnemonic.entropy_to_mnemonic(entropy)
    assert mnemonic == "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
    assert Mnemonic.mnemonic_to_entropy(mnemonic) == entropy
  end


  # also test that word count is 2048
end
