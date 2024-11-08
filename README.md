# tx_util

A utility library to help constructing `Transaction` and `ScriptContext`, useful for testing.

| ℹ️  | Package info    | aiken-extra/tx_util v2.215.202411 | 🐞  |
| --- | --------------- | --------------------------------- | --- |
| 🟢  | **Depends on**  | **aiken-lang/stdlib v0f88f8ffce60b91ae3e4b3a3f40bab153e494760**      | ✔️  |
| 🟢  | **Tested with** | **aiken v1.1.5**                  | ✔️  |

## Usage Example

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
