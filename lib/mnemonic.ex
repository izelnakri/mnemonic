require IEx
defmodule Mnemonic do
  @moduledoc """
  Documentation for Mnemonic.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Mnemonic.hello
      :world

  """
  @words Mnemonic.Words.all()

  @invalid_entropy "Invalid entropy"
  @invalid_mnemonic "Invalid mnemonic"
  @invalid_checksum "Invalid mnemonic checksum"

  def generate(strength \\ 256)
  def generate(strength) when rem(strength, 32) !== 0, do: raise @invalid_entropy
  def generate(strength) do
    entropy = :crypto.strong_rand_bytes(trunc(strength / 8))
    entropy_to_mnemonic(entropy)
  end

  def entropy_to_mnemonic(entropy) do
    target_entropy = case String.valid?(entropy) do
      true -> Base.decode16!(entropy, case: :mixed) # NOTE: gives error sometimes
      _ -> entropy
    end
    entropy_length = byte_size(target_entropy)

    cond do
      entropy_length < 16 -> raise @invalid_entropy
      entropy_length > 32 -> raise @invalid_entropy
      rem(entropy_length, 4) !== 0 -> raise @invalid_entropy
      true ->
        entropy_bits = to_binary_string(target_entropy)
        checksum_bits = derive_checksum_bits(target_entropy)
        bits = entropy_bits <> checksum_bits

        Regex.scan(~r/(.{1,11})/, bits)
        |> Enum.map(fn(x) -> List.first(x) end)
        |> Enum.map(fn(binary) ->
          index = binary_to_byte(binary)
          Enum.at(@words, index)
        end)
        |> Enum.join(" ")
    end
  end

  def mnemonic_to_entropy(mnemonic) do
    words = mnemonic |> String.split(" ")
    if rem(length(words), 3) !== 0, do: raise @invalid_mnemonic

    bits = Enum.map(words, fn(word) ->
        index = Enum.find_index(@words, fn(element) -> element == word end)
        if !index, do: raise @invalid_mnemonic

        Integer.to_string(index, 2) |> lpad("0", 11)
      end)
      |> Enum.join("")

    divider_index = trunc(Float.floor(String.length(bits) / 33) * 32)
    entropy_bits = bits |> String.slice(0..(divider_index - 1))
    checksum_bits = bits |> String.slice(divider_index..-1)

    entropy_bytes = Regex.scan(~r/(.{1,8})/, entropy_bits)
      |> Enum.map(fn(x) -> List.first(x) end)
      |> Enum.map(fn(x) -> binary_to_byte(x) end)

    entropy_bytes_length = length(entropy_bytes)

    cond do
      entropy_bytes_length < 16 -> raise @invalid_entropy
      entropy_bytes_length > 32 -> raise @invalid_entropy
      rem(entropy_bytes_length, 4) !== 0 -> raise @invalid_entropy
      true ->
        entropy = :binary.list_to_bin(entropy_bytes)
        new_checksum = derive_checksum_bits(entropy)
        if new_checksum !== checksum_bits, do: raise @invalid_checksum

        Base.encode16(entropy)
    end
  end

  # def mnemonic_to_seed(mnemonic, password) do
  #
  # end

  # def validate(words) do # NOTE: maybe
  #
  # end

  def binary_to_byte(bin), do: Integer.parse(bin, 2) |> elem(0)

  def derive_checksum_bits(entropy) do
    checksum_length = (byte_size(entropy) * 8) / 32 |> trunc
    hash = :crypto.hash(:sha256, entropy)
    to_binary_string(hash) |> String.slice(0..(checksum_length - 1))
  end

  def to_binary_string(binary) do
    :binary.bin_to_list(binary)
    |> Enum.map(fn(x) -> Integer.to_string(x, 2) |> lpad("0", 8) end)
    |> Enum.join("")
  end

  defp lpad(string, pad_string, length) do
    if String.length(string) < length do
      lpad(pad_string <> string, pad_string, length)
    else
      string
    end
  end
end
