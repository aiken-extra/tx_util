//// Usage example,
//// ```
//// test validate_something() {
////   // Arrange:
////   let nft = from_asset("NftPolicy", "NftName", 1)
////   let token = from_asset("TokenPolicy", "TokenName", 10)
////   // use aiken/transaction/value.{from_asset}
////   let asset_1 = from_asset("AssetPolicy1", "AssetName1", 1)
////   let asset_2 = from_asset("AssetPolicy2", "AssetName2", 1000)
////   let asset_2_partial = from_asset("AssetPolicy2", "AssetName2", 100)
////   
////   // tx_util/builder:
////   let tx_ref_in = new_tx_input(
////       "TxRefInHash",                       // tx_hash: Hash<Blake2b_256, Transaction>
////       from_verification_key("PubKeyHash"), // address: use aiken/transaction/credential
////       user_ada,                            // lovelace: Int
////       NoDatum,                             // datum: use aiken/transaction.{NoDatum}
////     ) |> with_asset_of_tx_input(token)
////   
////   let tx_in = new_tx_input(
////       "TxInHash",                          // tx_hash: Hash<Blake2b_256, Transaction>
////       from_script("ValidatorHash"),        // address: use aiken/transaction/credential
////       input_ada,                           // lovelace: Int
////       InlineDatum(old_datum),              // datum: use aiken/transaction.{InlineDatum}
////     ) |> with_asset_of_tx_input(nft)
////       |> with_asset_of_tx_input(asset_1)
////       |> with_asset_of_tx_input(asset_2)
////   
////   let tx_out = new_tx_output(
////       from_script("ValidatorHash"),        // address: use aiken/transaction/credential
////       output_ada,                          // lovelace: Int
////       InlineDatum(new_datum),              // datum: use aiken/transaction.{InlineDatum}
////     ) |> add_asset_to_tx_output(nft)
////       |> add_asset_to_tx_output(asset_1)
////       |> add_asset_to_tx_output(asset_2_partial)
////   
////   let ctx = empty()
////       |> build_txn_context()
////       |> add_tx_ref_input(tx_ref_in)
////       |> add_tx_input(tx_in)
////       |> add_tx_output(tx_out)
////       |> add_signatory("PubKeyHash")
////   
////   // Assert:
////   !validator.validate(script_arg_1, script_arg_2, datum, redeemer, ctx)
//// }
//// ```

use aiken/dict
use aiken/hash.{Blake2b_224, Blake2b_256, Hash}
use aiken/interval.{Interval}
use aiken/list.{push}
use aiken/time.{PosixTime}
use aiken/transaction.{
  Datum, Mint, Output, OutputReference, ScriptContext, Spend, Transaction,
  TransactionId,
}
use aiken/transaction/credential.{Address, VerificationKey}
use aiken/transaction/value.{
  MintedValue, PolicyId, Value, from_lovelace, merge, to_minted_value, zero,
}

// type Qty =
//   Int

// type FlattenValue =
//   (PolicyId, AssetName, Qty)

// type FlattenValues =
//   List<FlattenValue>

// type ValidatorHash =
//   Hash<Blake2b_224, Script>

type PubKeyHash =
  Hash<Blake2b_224, VerificationKey>

type TxHash =
  Hash<Blake2b_256, Transaction>

/// The initial function that serves as the starting point to construct `ScriptContext`
pub fn build_txn_context(validity_range: Interval<PosixTime>) -> ScriptContext {
  ScriptContext(
    Transaction {
      inputs: [],
      reference_inputs: [],
      outputs: [],
      fee: from_lovelace(2_000_000),
      mint: zero() |> to_minted_value(),
      certificates: [],
      withdrawals: dict.new(),
      validity_range,
      extra_signatories: [],
      redeemers: dict.new(),
      datums: dict.new(),
      id: TransactionId(""),
    },
    Spend(
      OutputReference { transaction_id: TransactionId(""), output_index: 0 },
    ),
  )
}

/// Set `ScriptPurpose.Mint(PolicyId)` = `policy_id`
/// and `Transaction.MintedValue` = `assets`
pub fn mint_assets(
  context: ScriptContext,
  policy_id: PolicyId,
  assets: MintedValue,
) -> ScriptContext {
  ScriptContext(
    Transaction {
      inputs: context.transaction.inputs,
      reference_inputs: context.transaction.reference_inputs,
      outputs: context.transaction.outputs,
      fee: context.transaction.fee,
      mint: assets,
      certificates: context.transaction.certificates,
      withdrawals: context.transaction.withdrawals,
      validity_range: context.transaction.validity_range,
      extra_signatories: context.transaction.extra_signatories,
      redeemers: context.transaction.redeemers,
      datums: context.transaction.datums,
      id: context.transaction.id,
    },
    Mint(policy_id),
  )
}

/// Push `signatory` to `ScriptContext.transaction.extra_signatories`
pub fn add_signatory(
  context: ScriptContext,
  signatory: PubKeyHash,
) -> ScriptContext {
  ScriptContext(
    Transaction {
      inputs: context.transaction.inputs,
      reference_inputs: context.transaction.reference_inputs,
      outputs: context.transaction.outputs,
      fee: context.transaction.fee,
      mint: context.transaction.mint,
      certificates: context.transaction.certificates,
      withdrawals: context.transaction.withdrawals,
      validity_range: context.transaction.validity_range,
      extra_signatories: context.transaction.extra_signatories
        |> push(signatory),
      redeemers: context.transaction.redeemers,
      datums: context.transaction.datums,
      id: context.transaction.id,
    },
    context.purpose,
  )
}

/// Push `tx_ref_in` to `ScriptContext.transaction.reference_inputs`
pub fn add_tx_ref_input(
  context: ScriptContext,
  tx_ref_in: transaction.Input,
) -> ScriptContext {
  ScriptContext(
    Transaction {
      inputs: context.transaction.inputs,
      reference_inputs: context.transaction.reference_inputs
        |> push(tx_ref_in),
      outputs: context.transaction.outputs,
      fee: context.transaction.fee,
      mint: context.transaction.mint,
      certificates: context.transaction.certificates,
      withdrawals: context.transaction.withdrawals,
      validity_range: context.transaction.validity_range,
      extra_signatories: context.transaction.extra_signatories,
      redeemers: context.transaction.redeemers,
      datums: context.transaction.datums,
      id: context.transaction.id,
    },
    context.purpose,
  )
}

/// Push `tx_in` to `ScriptContext.transaction.inputs`
pub fn add_tx_input(
  context: ScriptContext,
  tx_in: transaction.Input,
) -> ScriptContext {
  ScriptContext(
    Transaction {
      inputs: context.transaction.inputs
        |> push(tx_in),
      reference_inputs: context.transaction.reference_inputs,
      outputs: context.transaction.outputs,
      fee: context.transaction.fee,
      mint: context.transaction.mint,
      certificates: context.transaction.certificates,
      withdrawals: context.transaction.withdrawals,
      validity_range: context.transaction.validity_range,
      extra_signatories: context.transaction.extra_signatories,
      redeemers: context.transaction.redeemers,
      datums: context.transaction.datums,
      id: context.transaction.id,
    },
    context.purpose,
  )
}

/// Construct a transaction input.
pub fn new_tx_input(
  tx_hash: TxHash,
  address: Address,
  lovelace: Int,
  datum: Datum,
) -> transaction.Input {
  transaction.Input(
    OutputReference(TransactionId(tx_hash), 0),
    Output {
      address,
      value: lovelace |> from_lovelace,
      datum,
      reference_script: None,
    },
  )
}

/// Add asset(s) to a transaction input.
pub fn with_asset_of_tx_input(
  input: transaction.Input,
  asset: Value,
) -> transaction.Input {
  transaction.Input(
    input.output_reference,
    Output {
      address: input.output.address,
      value: input.output.value
        |> merge(asset),
      datum: input.output.datum,
      reference_script: input.output.reference_script,
    },
  )
}

/// Push `tx_out` to `ScriptContext.transaction.outputs`
pub fn add_tx_output(
  context: ScriptContext,
  tx_out: transaction.Output,
) -> ScriptContext {
  ScriptContext(
    Transaction {
      inputs: context.transaction.inputs,
      reference_inputs: context.transaction.reference_inputs,
      outputs: context.transaction.outputs
        |> push(tx_out),
      fee: context.transaction.fee,
      mint: context.transaction.mint,
      certificates: context.transaction.certificates,
      withdrawals: context.transaction.withdrawals,
      validity_range: context.transaction.validity_range,
      extra_signatories: context.transaction.extra_signatories,
      redeemers: context.transaction.redeemers,
      datums: context.transaction.datums,
      id: context.transaction.id,
    },
    context.purpose,
  )
}

/// Construct a transaction output.
pub fn new_tx_output(
  address: Address,
  lovelace: Int,
  datum: Datum,
) -> transaction.Output {
  transaction.Output {
    address,
    value: lovelace |> from_lovelace,
    datum,
    reference_script: None,
  }
}

/// Add asset(s) to a transaction output.
pub fn add_asset_to_tx_output(
  output: transaction.Output,
  asset: Value,
) -> transaction.Output {
  transaction.Output {
    address: output.address,
    value: output.value
      |> merge(asset),
    datum: output.datum,
    reference_script: output.reference_script,
  }
}
