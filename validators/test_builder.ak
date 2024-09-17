use aiken/interval.{after}
use cardano/address
use cardano/assets.{from_asset_list}
use cardano/certificate.{DelegateBoth, RegisterAndDelegateCredential}
use cardano/governance.{NicePoll, ProposalProcedure, StakePool}
use cardano/script_context.{ScriptContext}
use cardano/transaction.{OutputReference, Transaction}
use tx_util/builder.{
  build_context, mint_assets, propose_procedure, publish_certificate,
  set_transaction, spend_utxo, vote_governance, withdraw_stake_rewards,
}
use tx_util/builder/txn.{set_validity_range}

// ## Test Starting Point

test testing_build_context() {
  // Arrange:
  let now = 1234567890000

  let ctx_raw =
    ScriptContext {
      transaction: transaction.placeholder |> set_validity_range(now |> after),
      redeemer: "Redeemer",
      info: script_context.Spending {
        output: OutputReference {
          transaction_id: #"0000000000000000000000000000000000000000000000000000000000000000",
          output_index: 0,
        },
        datum: None,
      },
    }

  let ctx_new = after(now) |> build_context("Redeemer")

  // Trace:
  //   trace @"ctx_raw": ctx_raw
  //   trace @"ctx_new": ctx_new
  // Assert:
  (ctx_raw == ctx_new)?
}

// ## Test Script Info

test testing_mint_assets() {
  // Arrange:
  let ctx_raw =
    ScriptContext {
      transaction: Transaction {
        ..transaction.placeholder,
        mint: from_asset_list(
          [Pair("PolicyId", [Pair("RefToken", 1), Pair("UsrToken", 20)])],
        ),
      },
      redeemer: Void,
      info: script_context.Minting("PolicyId"),
    }

  let ctx_new =
    interval.everything
      |> build_context(Void)
      |> mint_assets(
          "PolicyId",
          from_asset_list(
            [Pair("PolicyId", [Pair("RefToken", 1), Pair("UsrToken", 20)])],
          ),
        )

  // Trace:
  //   trace @"ctx_raw": ctx_raw
  //   trace @"ctx_new": ctx_new
  // Assert:
  (ctx_raw == ctx_new)?
}

test testing_spend_utxo() {
  // Arrange:
  let utxo = OutputReference("TransactionId", 0)

  let ctx_raw =
    ScriptContext {
      transaction: transaction.placeholder,
      redeemer: Void,
      info: script_context.Spending(utxo, None),
    }

  let ctx_new =
    interval.everything |> build_context(Void) |> spend_utxo(utxo, None)

  // Trace:
  //   trace @"ctx_raw": ctx_raw
  //   trace @"ctx_new": ctx_new
  // Assert:
  (ctx_raw == ctx_new)?
}

test testing_withdraw_stake_rewards() {
  // Arrange:
  let ctx_raw =
    ScriptContext {
      transaction: Transaction {
        ..transaction.placeholder,
        withdrawals: [Pair("ScriptHash" |> address.Script, 0)],
      },
      redeemer: Void,
      info: script_context.Withdrawing("ScriptHash" |> address.Script),
    }

  let ctx_new =
    interval.everything
      |> build_context(Void)
      |> withdraw_stake_rewards("ScriptHash" |> address.Script)

  // Trace:
  //   trace @"ctx_raw": ctx_raw
  //   trace @"ctx_new": ctx_new
  // Assert:
  (ctx_raw == ctx_new)?
}

test testing_publish_certificate() {
  // Arrange:
  let registered_drep = "ScriptHash" |> address.Script |> certificate.Registered
  let stake_pool_id = "StakePoolId"

  let certificate =
    RegisterAndDelegateCredential {
      credential: "ScriptHash" |> address.Script,
      delegate: DelegateBoth {
        stake_pool: stake_pool_id,
        delegate_representative: registered_drep,
      },
      deposit: 80_000_000,
    }

  let ctx_raw =
    ScriptContext {
      transaction: transaction.placeholder,
      redeemer: Void,
      info: script_context.Publishing(0, certificate),
    }

  let ctx_new =
    interval.everything
      |> build_context(Void)
      |> publish_certificate(certificate, 0)

  // Trace:
  //   trace @"ctx_raw": ctx_raw
  //   trace @"ctx_new": ctx_new
  // Assert:
  (ctx_raw == ctx_new)?
}

test testing_vote_governance() {
  // Arrange:
  let spo = "VerificationKeyHash" |> StakePool

  let ctx_raw =
    ScriptContext {
      transaction: Transaction {
        ..transaction.placeholder,
        votes: [Pair(spo, [])],
      },
      redeemer: Void,
      info: script_context.Voting(spo),
    }

  let ctx_new =
    interval.everything |> build_context(Void) |> vote_governance(spo)

  // Trace:
  //   trace @"ctx_raw": ctx_raw
  //   trace @"ctx_new": ctx_new
  // Assert:
  (ctx_raw == ctx_new)?
}

test testing_propose_procedure() {
  // Arrange:
  let index = 5
  let nice_poll =
    ProposalProcedure {
      deposit: 500_000_000,
      return_address: "ScriptHash" |> address.Script,
      governance_action: NicePoll,
    }

  let ctx_raw =
    ScriptContext {
      transaction: Transaction {
        ..transaction.placeholder,
        proposal_procedures: [nice_poll],
      },
      redeemer: Void,
      info: script_context.Proposing {
        at: index,
        proposal_procedure: nice_poll,
      },
    }

  let ctx_new =
    interval.everything
      |> build_context(Void)
      |> propose_procedure(nice_poll, index)

  // Trace:
  //   trace @"ctx_raw": ctx_raw
  //   trace @"ctx_new": ctx_new
  // Assert:
  (ctx_raw == ctx_new)?
}

// ## Test Set Transaction

test testing_set_transaction() {
  // Arrange:
  let ctx_raw =
    ScriptContext {
      transaction: transaction.placeholder,
      redeemer: Void,
      info: script_context.Spending {
        output: OutputReference {
          transaction_id: #"0000000000000000000000000000000000000000000000000000000000000000",
          output_index: 0,
        },
        datum: None,
      },
    }

  let ctx_new =
    interval.everything
      |> build_context(Void)
      |> set_transaction(transaction.placeholder)

  // Trace:
  //   trace @"ctx_raw": ctx_raw
  //   trace @"ctx_new": ctx_new
  // Assert:
  (ctx_raw == ctx_new)?
}
