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
////   let ctx = empty
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

use aiken/collection.{Index}
use aiken/collection/dict.{Dict}
use aiken/collection/list.{push}
use aiken/collection/pairs
use aiken/crypto.{Blake2b_224, Blake2b_256, Hash, Script, VerificationKey}
use aiken/interval.{Interval}
use cardano/address.{Address, Credential}
use cardano/assets.{Lovelace, PolicyId, Value, from_lovelace, merge}
use cardano/certificate.{Certificate}
use cardano/governance.{ProposalProcedure, Voter}
use cardano/script_context.{
  Minting, Proposing, Publishing, ScriptContext, Spending, Voting, Withdrawing,
}
use cardano/transaction.{
  Datum, Output, OutputReference, Redeemer, ScriptPurpose, Transaction,
  TransactionId,
}

// type Qty =
//   Int

// type FlattenValue =
//   (PolicyId, AssetName, Qty)

// type FlattenValues =
//   List<FlattenValue>

type ValidatorHash =
  Hash<Blake2b_224, Script>

type PubKeyHash =
  Hash<Blake2b_224, VerificationKey>

type TxHash =
  Hash<Blake2b_256, Transaction>

// ## Starting Point

/// The initial function that serves as the starting point to construct `ScriptContext`
///
/// Example,
/// ```
/// let ctx = after(now) |> build_txn_context()
/// ```
pub fn build_txn_context(validity_range: Interval<Int>) -> ScriptContext {
  ScriptContext(
    Transaction {
      ..transaction.placeholder,
      validity_range: validity_range,
      fee: 2_000_000,
      id: "",
    },
    Void,
    Spending(OutputReference { transaction_id: "", output_index: 0 }, None),
  )
}

/// **OPTIONAL**: Set `ScriptContext.transaction.id`
pub fn set_id(context: ScriptContext, id: TransactionId) -> ScriptContext {
  ScriptContext(
    Transaction { ..context.transaction, id: id },
    context.redeemer,
    context.info,
  )
}

// ## Script Purpose

/// Set the Spending ScriptPurpose `OutputReference`
pub fn spend(context: ScriptContext, o_ref: OutputReference) -> ScriptContext {
  ScriptContext(context.transaction, context.redeemer, Spending(o_ref, None))
}

/// Set `ScriptPurpose.Mint(PolicyId)` = `policy_id`
/// and `Transaction.MintedValue` = `assets`
pub fn mint_assets(
  context: ScriptContext,
  policy_id: PolicyId,
  assets: Value,
) -> ScriptContext {
  ScriptContext(
    Transaction { ..context.transaction, mint: assets },
    context.redeemer,
    Minting(policy_id),
  )
}

/// Set the Withdrawing ScriptPurpose `Credential`
pub fn withdraw_stake_rewards(
  context: ScriptContext,
  credential: Credential,
) -> ScriptContext {
  ScriptContext(context.transaction, context.redeemer, Withdrawing(credential))
}

/// Set the Publishing ScriptPurpose `Certificate` at `Index`
pub fn publish_stake(
  context: ScriptContext,
  certificate: Certificate,
  at: Index,
) -> ScriptContext {
  ScriptContext(
    context.transaction,
    context.redeemer,
    Publishing(at, certificate),
  )
}

/// Set the Voting ScriptPurpose `Voter`
pub fn vote_governance(context: ScriptContext, voter: Voter) -> ScriptContext {
  ScriptContext(context.transaction, context.redeemer, Voting(voter))
}

/// Set the Proposing ScriptPurpose `ProposalProcedure` at `Index`
pub fn propose_governance(
  context: ScriptContext,
  proposal_procedure: ProposalProcedure,
  at: Index,
) -> ScriptContext {
  ScriptContext(
    context.transaction,
    context.redeemer,
    Proposing(at, proposal_procedure),
  )
}

// ## Sign Transaction

/// Push `signatory` to `ScriptContext.transaction.extra_signatories`
pub fn add_signatory(
  context: ScriptContext,
  signatory: PubKeyHash,
) -> ScriptContext {
  ScriptContext(
    Transaction {
      ..context.transaction,
      extra_signatories: context.transaction.extra_signatories
        |> push(signatory),
    },
    context.redeemer,
    context.info,
  )
}

// ## Add Reference Input

/// Push `tx_ref_in` to `ScriptContext.transaction.reference_inputs`
pub fn add_tx_ref_input(
  context: ScriptContext,
  tx_ref_in: transaction.Input,
) -> ScriptContext {
  ScriptContext(
    Transaction {
      ..context.transaction,
      reference_inputs: context.transaction.reference_inputs
        |> push(tx_ref_in),
    },
    context.redeemer,
    context.info,
  )
}

// ## Add Transaction Input

/// Push `tx_in` to `ScriptContext.transaction.inputs`
///
/// Example,
/// ```
/// let tx_in = new_tx_input(...)
///     |> attach_ref_script_to_tx_input(validator_hash)
///     |> with_asset_of_tx_input(value)
///
/// let ctx = after(now)
///     |> build_txn_context()
///     |> add_tx_input(tx_in)
/// ```
pub fn add_tx_input(
  context: ScriptContext,
  tx_in: transaction.Input,
) -> ScriptContext {
  ScriptContext(
    Transaction {
      ..context.transaction,
      inputs: context.transaction.inputs
        |> push(tx_in),
    },
    context.redeemer,
    context.info,
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
    OutputReference(tx_hash, 0),
    Output {
      address,
      value: lovelace |> from_lovelace,
      datum,
      reference_script: None,
    },
  )
}

/// Attach a reference script to a transaction input.
pub fn attach_ref_script_to_tx_input(
  input: transaction.Input,
  ref_script: ValidatorHash,
) -> transaction.Input {
  transaction.Input(
    input.output_reference,
    Output {
      address: input.output.address,
      value: input.output.value,
      datum: input.output.datum,
      reference_script: Some(ref_script),
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

// ## Add Transaction Output

/// Push `tx_out` to `ScriptContext.transaction.outputs`
///
/// Example,
/// ```
/// let tx_out = new_tx_output(...)
///     |> attach_ref_script_to_tx_output(validator_hash)
///     |> add_asset_to_tx_output(value)
///
/// let ctx = after(now)
///     |> build_txn_context()
///     |> add_tx_output(tx_out)
/// ```
pub fn add_tx_output(
  context: ScriptContext,
  tx_out: transaction.Output,
) -> ScriptContext {
  ScriptContext(
    Transaction {
      ..context.transaction,
      outputs: context.transaction.outputs
        |> push(tx_out),
    },
    context.redeemer,
    context.info,
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

/// Attach a reference script to a transaction output.
pub fn attach_ref_script_to_tx_output(
  output: transaction.Output,
  ref_script: ValidatorHash,
) -> transaction.Output {
  transaction.Output {
    address: output.address,
    value: output.value,
    datum: output.datum,
    reference_script: Some(ref_script),
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

// ## Add Certificate

/// Push `certificate` to `ScriptContext.transaction.certificates`
pub fn add_certificate(
  context: ScriptContext,
  certificate: Certificate,
) -> ScriptContext {
  ScriptContext(
    Transaction {
      ..context.transaction,
      certificates: context.transaction.certificates
        |> push(certificate),
    },
    context.redeemer,
    context.info,
  )
}

// ## Transaction Withdrawals

/// Set `withdrawals` to `ScriptContext.transaction.withdrawals`
pub fn set_withdrawals(
  context: ScriptContext,
  withdrawals: Pairs<Credential, Lovelace>,
) -> ScriptContext {
  ScriptContext(
    Transaction { ..context.transaction, withdrawals: withdrawals },
    context.redeemer,
    context.info,
  )
}

/// Insert `withdrawal` to `ScriptContext.transaction.withdrawals`
pub fn insert_withdrawal(
  context: ScriptContext,
  withdrawal_key,
  withdrawal_value,
  withdrawal_compare,
) -> ScriptContext {
  ScriptContext(
    Transaction {
      ..context.transaction,
      withdrawals: context.transaction.withdrawals
        |> pairs.repsert_by_ascending_key(
            key: withdrawal_key,
            value: withdrawal_value,
            compare: withdrawal_compare,
          ),
    },
    context.redeemer,
    context.info,
  )
}

// /// Insert `withdrawal` with a merging function to `ScriptContext.transaction.withdrawals`
// pub fn insert_withdrawal_with(
//   context: ScriptContext,
//   withdrawal_key,
//   withdrawal_value,
//   withdrawal_compare,
//   withdrawal_with,
// ) -> ScriptContext {
//   ScriptContext(
//     Transaction {
//       inputs: context.transaction.inputs,
//       reference_inputs: context.transaction.reference_inputs,
//       outputs: context.transaction.outputs,
//       fee: context.transaction.fee,
//       mint: context.transaction.mint,
//       certificates: context.transaction.certificates,
//       withdrawals: context.transaction.withdrawals
//         |> insert_with(
//             key: withdrawal_key,
//             value: withdrawal_value,
//             with: withdrawal_with,
//             compare: withdrawal_compare,
//           ),
//       validity_range: context.transaction.validity_range,
//       extra_signatories: context.transaction.extra_signatories,
//       redeemers: context.transaction.redeemers,
//       datums: context.transaction.datums,
//       id: context.transaction.id,
//     },
//     context.purpose,
//   )
// }

// /// Union `withdrawal` to `ScriptContext.transaction.withdrawals`
// pub fn union_withdrawal(
//   context: ScriptContext,
//   withdrawal_key,
//   withdrawal_value,
//   withdrawal_compare,
// ) -> ScriptContext {
//   ScriptContext(
//     Transaction {
//       inputs: context.transaction.inputs,
//       reference_inputs: context.transaction.reference_inputs,
//       outputs: context.transaction.outputs,
//       fee: context.transaction.fee,
//       mint: context.transaction.mint,
//       certificates: context.transaction.certificates,
//       withdrawals: [(withdrawal_key, withdrawal_value)]
//         |> from_pairs(withdrawal_compare)
//         |> union(context.transaction.withdrawals, withdrawal_compare),
//       validity_range: context.transaction.validity_range,
//       extra_signatories: context.transaction.extra_signatories,
//       redeemers: context.transaction.redeemers,
//       datums: context.transaction.datums,
//       id: context.transaction.id,
//     },
//     context.purpose,
//   )
// }

// /// Union `withdrawal` with a merging function to `ScriptContext.transaction.withdrawals`
// pub fn union_withdrawal_with(
//   context: ScriptContext,
//   withdrawal_key,
//   withdrawal_value,
//   withdrawal_compare,
//   withdrawal_with,
// ) -> ScriptContext {
//   ScriptContext(
//     Transaction {
//       inputs: context.transaction.inputs,
//       reference_inputs: context.transaction.reference_inputs,
//       outputs: context.transaction.outputs,
//       fee: context.transaction.fee,
//       mint: context.transaction.mint,
//       certificates: context.transaction.certificates,
//       withdrawals: [(withdrawal_key, withdrawal_value)]
//         |> from_pairs(withdrawal_compare)
//         |> union_with(
//             context.transaction.withdrawals,
//             withdrawal_with,
//             withdrawal_compare,
//           ),
//       validity_range: context.transaction.validity_range,
//       extra_signatories: context.transaction.extra_signatories,
//       redeemers: context.transaction.redeemers,
//       datums: context.transaction.datums,
//       id: context.transaction.id,
//     },
//     context.purpose,
//   )
// }

// /// Delete `withdrawal` from `ScriptContext.transaction.withdrawals`
// pub fn delete_withdrawal(
//   context: ScriptContext,
//   withdrawal_key,
// ) -> ScriptContext {
//   ScriptContext(
//     Transaction {
//       inputs: context.transaction.inputs,
//       reference_inputs: context.transaction.reference_inputs,
//       outputs: context.transaction.outputs,
//       fee: context.transaction.fee,
//       mint: context.transaction.mint,
//       certificates: context.transaction.certificates,
//       withdrawals: context.transaction.withdrawals
//         |> delete(withdrawal_key),
//       validity_range: context.transaction.validity_range,
//       extra_signatories: context.transaction.extra_signatories,
//       redeemers: context.transaction.redeemers,
//       datums: context.transaction.datums,
//       id: context.transaction.id,
//     },
//     context.purpose,
//   )
// }

// ## Transaction Redeemers

/// Set `redeemers` to `ScriptContext.transaction.redeemers`
pub fn set_redeemers(
  context: ScriptContext,
  redeemers: Pairs<ScriptPurpose, Redeemer>,
) -> ScriptContext {
  ScriptContext(
    Transaction { ..context.transaction, redeemers: redeemers },
    context.redeemer,
    context.info,
  )
}

/// Insert `redeemer` to `ScriptContext.transaction.redeemers`
pub fn insert_redeemer(
  context: ScriptContext,
  redeemer_key,
  redeemer_value,
  redeemer_compare,
) -> ScriptContext {
  ScriptContext(
    Transaction {
      ..context.transaction,
      redeemers: context.transaction.redeemers
        |> pairs.repsert_by_ascending_key(
            key: redeemer_key,
            value: redeemer_value,
            compare: redeemer_compare,
          ),
    },
    context.redeemer,
    context.info,
  )
}

// /// Insert `redeemer` with a merging function to `ScriptContext.transaction.redeemers`
// pub fn insert_redeemer_with(
//   context: ScriptContext,
//   redeemer_key,
//   redeemer_value,
//   redeemer_compare,
//   redeemer_with,
// ) -> ScriptContext {
//   ScriptContext(
//     Transaction {
//       inputs: context.transaction.inputs,
//       reference_inputs: context.transaction.reference_inputs,
//       outputs: context.transaction.outputs,
//       fee: context.transaction.fee,
//       mint: context.transaction.mint,
//       certificates: context.transaction.certificates,
//       withdrawals: context.transaction.withdrawals,
//       validity_range: context.transaction.validity_range,
//       extra_signatories: context.transaction.extra_signatories,
//       redeemers: context.transaction.redeemers
//         |> insert_with(
//             key: redeemer_key,
//             value: redeemer_value,
//             with: redeemer_with,
//             compare: redeemer_compare,
//           ),
//       datums: context.transaction.datums,
//       id: context.transaction.id,
//     },
//     context.purpose,
//   )
// }

// /// Union `redeemer` to `ScriptContext.transaction.redeemers`
// pub fn union_redeemer(
//   context: ScriptContext,
//   redeemer_key,
//   redeemer_value,
//   redeemer_compare,
// ) -> ScriptContext {
//   ScriptContext(
//     Transaction {
//       inputs: context.transaction.inputs,
//       reference_inputs: context.transaction.reference_inputs,
//       outputs: context.transaction.outputs,
//       fee: context.transaction.fee,
//       mint: context.transaction.mint,
//       certificates: context.transaction.certificates,
//       withdrawals: context.transaction.withdrawals,
//       validity_range: context.transaction.validity_range,
//       extra_signatories: context.transaction.extra_signatories,
//       redeemers: [(redeemer_key, redeemer_value)]
//         |> from_pairs(redeemer_compare)
//         |> union(context.transaction.redeemers, redeemer_compare),
//       datums: context.transaction.datums,
//       id: context.transaction.id,
//     },
//     context.purpose,
//   )
// }

// /// Union `redeemer` with a merging function to `ScriptContext.transaction.redeemers`
// pub fn union_redeemer_with(
//   context: ScriptContext,
//   redeemer_key,
//   redeemer_value,
//   redeemer_compare,
//   redeemer_with,
// ) -> ScriptContext {
//   ScriptContext(
//     Transaction {
//       inputs: context.transaction.inputs,
//       reference_inputs: context.transaction.reference_inputs,
//       outputs: context.transaction.outputs,
//       fee: context.transaction.fee,
//       mint: context.transaction.mint,
//       certificates: context.transaction.certificates,
//       withdrawals: context.transaction.withdrawals,
//       validity_range: context.transaction.validity_range,
//       extra_signatories: context.transaction.extra_signatories,
//       redeemers: [(redeemer_key, redeemer_value)]
//         |> from_pairs(redeemer_compare)
//         |> union_with(
//             context.transaction.redeemers,
//             redeemer_with,
//             redeemer_compare,
//           ),
//       datums: context.transaction.datums,
//       id: context.transaction.id,
//     },
//     context.purpose,
//   )
// }

// /// Delete `redeemer` from `ScriptContext.transaction.redeemers`
// pub fn delete_redeemer(context: ScriptContext, redeemer_key) -> ScriptContext {
//   ScriptContext(
//     Transaction {
//       inputs: context.transaction.inputs,
//       reference_inputs: context.transaction.reference_inputs,
//       outputs: context.transaction.outputs,
//       fee: context.transaction.fee,
//       mint: context.transaction.mint,
//       certificates: context.transaction.certificates,
//       withdrawals: context.transaction.withdrawals,
//       validity_range: context.transaction.validity_range,
//       extra_signatories: context.transaction.extra_signatories,
//       redeemers: context.transaction.redeemers
//         |> delete(redeemer_key),
//       datums: context.transaction.datums,
//       id: context.transaction.id,
//     },
//     context.purpose,
//   )
// }

// ## Transaction Datums

/// Set `datums` from `ScriptContext.transaction.datums`
pub fn set_datums(
  context: ScriptContext,
  datums: Dict<ByteArray, Data>,
) -> ScriptContext {
  ScriptContext(
    Transaction { ..context.transaction, datums: datums },
    context.redeemer,
    context.info,
  )
}

// /// Insert `datum` to `ScriptContext.transaction.datums`
// pub fn insert_datum(
//   context: ScriptContext,
//   datum_key,
//   datum_value,
//   datum_compare,
// ) -> ScriptContext {
//   ScriptContext(
//     Transaction {
//       inputs: context.transaction.inputs,
//       reference_inputs: context.transaction.reference_inputs,
//       outputs: context.transaction.outputs,
//       fee: context.transaction.fee,
//       mint: context.transaction.mint,
//       certificates: context.transaction.certificates,
//       withdrawals: context.transaction.withdrawals,
//       validity_range: context.transaction.validity_range,
//       extra_signatories: context.transaction.extra_signatories,
//       redeemers: context.transaction.redeemers,
//       datums: context.transaction.datums
//         |> insert(key: datum_key, value: datum_value, compare: datum_compare),
//       id: context.transaction.id,
//     },
//     context.purpose,
//   )
// }

// /// Insert `datum` with a merging function to `ScriptContext.transaction.datums`
// pub fn insert_datum_with(
//   context: ScriptContext,
//   datum_key,
//   datum_value,
//   datum_compare,
//   datum_with,
// ) -> ScriptContext {
//   ScriptContext(
//     Transaction {
//       inputs: context.transaction.inputs,
//       reference_inputs: context.transaction.reference_inputs,
//       outputs: context.transaction.outputs,
//       fee: context.transaction.fee,
//       mint: context.transaction.mint,
//       certificates: context.transaction.certificates,
//       withdrawals: context.transaction.withdrawals,
//       validity_range: context.transaction.validity_range,
//       extra_signatories: context.transaction.extra_signatories,
//       redeemers: context.transaction.redeemers,
//       datums: context.transaction.datums
//         |> insert_with(
//             key: datum_key,
//             value: datum_value,
//             with: datum_with,
//             compare: datum_compare,
//           ),
//       id: context.transaction.id,
//     },
//     context.purpose,
//   )
// }

// /// Union `datum` to `ScriptContext.transaction.datums`
// pub fn union_datum(
//   context: ScriptContext,
//   datum_key,
//   datum_value,
//   datum_compare,
// ) -> ScriptContext {
//   ScriptContext(
//     Transaction {
//       inputs: context.transaction.inputs,
//       reference_inputs: context.transaction.reference_inputs,
//       outputs: context.transaction.outputs,
//       fee: context.transaction.fee,
//       mint: context.transaction.mint,
//       certificates: context.transaction.certificates,
//       withdrawals: context.transaction.withdrawals,
//       validity_range: context.transaction.validity_range,
//       extra_signatories: context.transaction.extra_signatories,
//       redeemers: context.transaction.redeemers,
//       datums: [(datum_key, datum_value)]
//         |> from_pairs(datum_compare)
//         |> union(context.transaction.datums, datum_compare),
//       id: context.transaction.id,
//     },
//     context.purpose,
//   )
// }

// /// Union `datum` with a merging function to `ScriptContext.transaction.datums`
// pub fn union_datum_with(
//   context: ScriptContext,
//   datum_key,
//   datum_value,
//   datum_compare,
//   datum_with,
// ) -> ScriptContext {
//   ScriptContext(
//     Transaction {
//       inputs: context.transaction.inputs,
//       reference_inputs: context.transaction.reference_inputs,
//       outputs: context.transaction.outputs,
//       fee: context.transaction.fee,
//       mint: context.transaction.mint,
//       certificates: context.transaction.certificates,
//       withdrawals: context.transaction.withdrawals,
//       validity_range: context.transaction.validity_range,
//       extra_signatories: context.transaction.extra_signatories,
//       redeemers: context.transaction.redeemers,
//       datums: [(datum_key, datum_value)]
//         |> from_pairs(datum_compare)
//         |> union_with(context.transaction.datums, datum_with, datum_compare),
//       id: context.transaction.id,
//     },
//     context.purpose,
//   )
// }

// /// Delete `datum` from `ScriptContext.transaction.datums`
// pub fn delete_datum(context: ScriptContext, datum_key) -> ScriptContext {
//   ScriptContext(
//     Transaction {
//       inputs: context.transaction.inputs,
//       reference_inputs: context.transaction.reference_inputs,
//       outputs: context.transaction.outputs,
//       fee: context.transaction.fee,
//       mint: context.transaction.mint,
//       certificates: context.transaction.certificates,
//       withdrawals: context.transaction.withdrawals,
//       validity_range: context.transaction.validity_range,
//       extra_signatories: context.transaction.extra_signatories,
//       redeemers: context.transaction.redeemers,
//       datums: context.transaction.datums
//         |> delete(datum_key),
//       id: context.transaction.id,
//     },
//     context.purpose,
//   )
// }

// ## Transaction Fees

/// Set `ScriptContext.transaction.fee`
pub fn set_fee(context: ScriptContext, fee: Lovelace) -> ScriptContext {
  ScriptContext(
    Transaction { ..context.transaction, fee: fee },
    context.redeemer,
    context.info,
  )
}
