//// Usage example,
//// ```
//// test negative_case() fail {
////   // Arrange:
////   let ctx = interval.empty
////     |> build_context("Redeemer")
////     |> vote_governance("VerificationKeyHash" |> StakePool)
////
////   ...
////
////   // tx_util/builder/txn:
////   let tx = ctx.transaction
////     |> add_tx_input(tx_in)
////     |> add_tx_output(tx_out)
////
////   // Assert:
////   ctx
////     |> set_transaction(tx)
////     |> validator.validate.else
//// }
//// ```

use aiken/collection
use aiken/interval.{Interval}
use cardano/address
use cardano/assets.{PolicyId}
use cardano/certificate.{Certificate}
use cardano/governance.{ProposalProcedure}
use cardano/script_context.{ScriptContext}
use cardano/transaction.{OutputReference, Transaction}
use tx_util/builder/txn

// ## Starting Point

/// The initial function that serves as the starting point to construct `ScriptContext`
///
/// Example,
/// ```
/// let ctx = after(now) |> build_context("Redeemer")
/// ```
pub fn build_context(
  validity_range: Interval<Int>,
  redeemer: transaction.Redeemer,
) -> ScriptContext {
  ScriptContext {
    transaction: transaction.placeholder
      |> txn.set_validity_range(validity_range),
    redeemer,
    info: script_context.Spending {
      output: OutputReference {
        transaction_id: #"0000000000000000000000000000000000000000000000000000000000000000",
        output_index: 0,
      },
      datum: None,
    },
  }
}

// ## Script Info

/// Set `Minting(policy_id)` to `ScriptContext.info`
/// and `assets` to `ScriptContext.transaction.mint`
pub fn mint_assets(
  ctx: ScriptContext,
  policy_id: PolicyId,
  assets: assets.Value,
) -> ScriptContext {
  ScriptContext {
    ..ctx,
    transaction: Transaction { ..ctx.transaction, mint: assets },
    info: script_context.Minting(policy_id),
  }
}

/// Set `Spending(utxo, datum)` to `ScriptContext.info`
pub fn spend_utxo(
  ctx: ScriptContext,
  utxo: OutputReference,
  datum: Option<Data>,
) -> ScriptContext {
  ScriptContext { ..ctx, info: script_context.Spending(utxo, datum) }
}

/// Set `Withdrawing(credential)` to `ScriptContext.info`
/// and `[Pair(credential, 0)]` to `ScriptContext.transaction.withdrawals`
pub fn withdraw_stake_rewards(
  ctx: ScriptContext,
  credential: address.Credential,
) -> ScriptContext {
  ScriptContext {
    ..ctx,
    transaction: Transaction {
      ..ctx.transaction,
      withdrawals: [Pair(credential, 0)],
    },
    info: script_context.Withdrawing(credential),
  }
}

/// Set `Publishing(at, certificate)` to `ScriptContext.info`
pub fn publish_certificate(
  ctx: ScriptContext,
  certificate: Certificate,
  at: collection.Index,
) -> ScriptContext {
  ScriptContext { ..ctx, info: script_context.Publishing(at, certificate) }
}

/// Set `Voting(voter)` to `ScriptContext.info`
/// and `[Pair(voter, [])]` to `ScriptContext.transaction.votes`
pub fn vote_governance(
  ctx: ScriptContext,
  voter: governance.Voter,
) -> ScriptContext {
  ScriptContext {
    ..ctx,
    transaction: Transaction { ..ctx.transaction, votes: [Pair(voter, [])] },
    info: script_context.Voting(voter),
  }
}

/// Set `Proposing(at, proposal_procedure)` to `ScriptContext.info`
/// and `[proposal_procedure]` to `ScriptContext.transaction.proposal_procedures`
pub fn propose_procedure(
  ctx: ScriptContext,
  proposal_procedure: ProposalProcedure,
  at: collection.Index,
) -> ScriptContext {
  ScriptContext {
    ..ctx,
    transaction: Transaction {
      ..ctx.transaction,
      proposal_procedures: [proposal_procedure],
    },
    info: script_context.Proposing(at, proposal_procedure),
  }
}

// ## Set Transaction

/// Set `tx` to `ScriptContext.transaction`
pub fn set_transaction(ctx: ScriptContext, tx: Transaction) -> ScriptContext {
  ScriptContext { ..ctx, transaction: tx }
}
