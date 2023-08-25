# tx_util

A utility library to help constructing `ScriptContext`, useful for testing.

| ℹ️  | Package info    | aiken-extra/tx_util v1.150.202308f                                                                  | 🪲  |
| --- | --------------- | --------------------------------------------------------------------------------------------------- | --- |
| 🟢  | **Depends on**  | **aiken-lang/stdlib v1.5.0**                                                                        | ✔️  |
| 🟢  | **Tested with** | **[1715496d5b](https://github.com/aiken-lang/aiken/tree/1715496d5ba70be939662b554b5aac9fff4d7f3e)** | ✔️  |

## Usage Example

```gleam
use tx_util/builder.{
    build_txn_context,
    mint_assets,
    add_tx_ref_input,
    add_tx_input,
    add_tx_output,
    add_signatory
}
```

```gleam
test validate_something() {
  ...
  let ctx =
    after(now) // aiken/interval.{after}
      |> build_txn_context()
      |> mint_assets("PolicyID", minted_assets)
      |> add_tx_ref_input(tx_ref_in)
      |> add_tx_input(tx_in_1)
      |> add_tx_input(tx_in_2)
      |> add_tx_output(tx_out_1)
      |> add_tx_output(tx_out_2)
      |> add_signatory("Signer")
  ...
  validator(..., ..., ctx)
}
```

Where,

```gleam
// aiken/transaction/value
minted_assets = to_minted_value(assets)

// tx_util/builder
tx_ref_in = new_tx_input(...)
      |> with_asset_of_tx_input(asset)

// tx_util/builder.{new_tx_input}
tx_in_1 = new_tx_input(...)

// tx_util/builder.{with_asset_of_tx_input}
tx_in_2 = new_tx_input(...)
      |> with_asset_of_tx_input(asset1)
      |> with_asset_of_tx_input(asset2)

// tx_util/builder.{new_tx_output}
tx_out_1 = new_tx_output(...)

// tx_util/builder.{add_asset_to_tx_output}
tx_out_2 = new_tx_output(...)
      |> add_asset_to_tx_output(asset1)
      |> add_asset_to_tx_output(asset2)
```
