# tx_util

> [!IMPORTANT]
> Deprecated in favor of [`aiken-extra/test_kit`](https://github.com/aiken-extra/test_kit)

A utility library to help constructing `Transaction`, `ScriptContext`, and mock hashes. Useful for testing.

| ℹ️  | Package info    | aiken-extra/tx_util v3.220.202501                                                        | 🐞  |
| --- | --------------- | ---------------------------------------------------------------------------------------- | --- |
| 🟢  | **Depends on**  | [**aiken-lang/stdlib v2.2.0**](https://github.com/aiken-lang/stdlib/releases/tag/v2.2.0) | ✅  |
| 🟢  | **Tested with** | [**aiken v1.1.9**](https://github.com/aiken-lang/aiken/releases/tag/v1.1.9)              | ✅  |

## Usage Examples

### `Transaction`

```gleam
use tx_util/builder/txn.{
    add_tx_ref_input,
    add_tx_input,
    add_tx_output,
    add_signatory,
}
```

```gleam
test validate_something() {
  ...
  let tx = transaction.placeholder
    |> add_tx_ref_input(tx_ref_in)
    |> add_tx_input(tx_in_1)
    |> add_tx_input(tx_in_2)
    |> add_tx_output(tx_out_1)
    |> add_tx_output(tx_out_2)
    |> add_signatory("Signer")
  ...
  // assert:
  validator.validate.spend(..., ..., ..., tx)
}
```

### `ScriptContext`

```gleam
use tx_util/builder.{
    build_context,
    mint_assets,
    set_transaction,
}
```

```gleam
test validate_something_else() fail {
  ...
  // aiken/interval.{after}:
  let ctx = after(now)
    |> build_context("Redeemer")
    |> mint_assets("PolicyID", assets)
  ...
  // tx_util/builder/txn:
  let tx = ctx.transaction
    |> add_tx_input(tx_in)
    |> add_tx_output(tx_out)
  ...
  // assert:
  ctx
    |> set_transaction(tx)
    |> validator.validate.else
}
```

### Mock Hashes

```gleam
use tx_util/mock
```

```gleam
mock_address(from_payment: 1, from_stake: 2)
mock_address("A", "B")    // Address with both Payment and Staking part
mock_address(True, False) // Address with only Payment part

mock_verification_key_credential(from: 34) // VerificationKey(#"00000000000000000000000000000000000000000000000000000034")
mock_script_credential(from: 567)          // Script(#"00000000000000000000000000000000000000000000000000000567")

mock_verification_key_hash(from: 89) // #"00000000000000000000000000000000000000000000000000000089"
mock_script_hash(from: 10)           // #"00000000000000000000000000000000000000000000000000000010"

mock_asset(1112, asset_name: "NFT", quantity: 1) // Value(#"00..............................001112", "NFT", 1)
mock_policy_id(1112)                             // #"00000000000000000000000000000000000000000000000000001112"

mock_output_reference(131415, output_index: 16) // OutputReference(#"00..............................00131415", 16)
mock_transaction_id(131415)                     // #"0000000000000000000000000000000000000000000000000000000000131415"

mock_blake2b_224(from: 224) // #"00000000000000000000000000000000000000000000000000000224"
mock_blake2b_256(from: 256) // #"0000000000000000000000000000000000000000000000000000000000000256"

mock_hash_from_bytearray(#"af", size: 4) // #"000000af"
mock_hash_from_int(123, size: 3)         // #"000123"
mock_hash(1, size: 2)                    // #"0001"
```
