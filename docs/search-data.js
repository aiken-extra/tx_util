window.Aiken.initSearch([{"doc":"tx_util/builder","title":"build_txn_context","content":"build_txn_context(validity_range: Interval&lt;Int&gt;) -&gt; ScriptContext\n The initial function that serves as the starting point to construct `ScriptContext`\n\n Example,\n ```\n let ctx = after(now) |&gt; build_txn_context()\n ```","url":"tx_util/builder.html#build_txn_context"},{"doc":"tx_util/builder","title":"set_id","content":"set_id(context: ScriptContext, id: TransactionId) -&gt; ScriptContext\n **OPTIONAL**: Set `ScriptContext.transaction.id`","url":"tx_util/builder.html#set_id"},{"doc":"tx_util/builder","title":"spend","content":"spend(context: ScriptContext, o_ref: OutputReference) -&gt; ScriptContext\n Set the Spending ScriptPurpose `OutputReference`","url":"tx_util/builder.html#spend"},{"doc":"tx_util/builder","title":"mint_assets","content":"mint_assets(\n  context: ScriptContext,\n  policy_id: PolicyId,\n  assets: Value,\n) -&gt; ScriptContext\n Set `ScriptPurpose.Mint(PolicyId)` = `policy_id`\n and `Transaction.MintedValue` = `assets`","url":"tx_util/builder.html#mint_assets"},{"doc":"tx_util/builder","title":"withdraw_stake_rewards","content":"withdraw_stake_rewards(\n  context: ScriptContext,\n  credential: Credential,\n) -&gt; ScriptContext\n Set the Withdrawing ScriptPurpose `Credential`","url":"tx_util/builder.html#withdraw_stake_rewards"},{"doc":"tx_util/builder","title":"publish_stake","content":"publish_stake(\n  context: ScriptContext,\n  certificate: Certificate,\n  at: Index,\n) -&gt; ScriptContext\n Set the Publishing ScriptPurpose `Certificate` at `Index`","url":"tx_util/builder.html#publish_stake"},{"doc":"tx_util/builder","title":"vote_governance","content":"vote_governance(context: ScriptContext, voter: Voter) -&gt; ScriptContext\n Set the Voting ScriptPurpose `Voter`","url":"tx_util/builder.html#vote_governance"},{"doc":"tx_util/builder","title":"propose_governance","content":"propose_governance(\n  context: ScriptContext,\n  proposal_procedure: ProposalProcedure,\n  at: Index,\n) -&gt; ScriptContext\n Set the Proposing ScriptPurpose `ProposalProcedure` at `Index`","url":"tx_util/builder.html#propose_governance"},{"doc":"tx_util/builder","title":"add_signatory","content":"add_signatory(context: ScriptContext, signatory: PubKeyHash) -&gt; ScriptContext\n Push `signatory` to `ScriptContext.transaction.extra_signatories`","url":"tx_util/builder.html#add_signatory"},{"doc":"tx_util/builder","title":"add_tx_ref_input","content":"add_tx_ref_input(\n  context: ScriptContext,\n  tx_ref_in: transaction.Input,\n) -&gt; ScriptContext\n Push `tx_ref_in` to `ScriptContext.transaction.reference_inputs`","url":"tx_util/builder.html#add_tx_ref_input"},{"doc":"tx_util/builder","title":"add_tx_input","content":"add_tx_input(context: ScriptContext, tx_in: transaction.Input) -&gt; ScriptContext\n Push `tx_in` to `ScriptContext.transaction.inputs`\n\n Example,\n ```\n let tx_in = new_tx_input(...)\n     |&gt; attach_ref_script_to_tx_input(validator_hash)\n     |&gt; with_asset_of_tx_input(value)\n\n let ctx = after(now)\n     |&gt; build_txn_context()\n     |&gt; add_tx_input(tx_in)\n ```","url":"tx_util/builder.html#add_tx_input"},{"doc":"tx_util/builder","title":"new_tx_input","content":"new_tx_input(\n  tx_hash: TxHash,\n  address: Address,\n  lovelace: Int,\n  datum: Datum,\n) -&gt; transaction.Input\n Construct a transaction input.","url":"tx_util/builder.html#new_tx_input"},{"doc":"tx_util/builder","title":"attach_ref_script_to_tx_input","content":"attach_ref_script_to_tx_input(\n  input: transaction.Input,\n  ref_script: ValidatorHash,\n) -&gt; transaction.Input\n Attach a reference script to a transaction input.","url":"tx_util/builder.html#attach_ref_script_to_tx_input"},{"doc":"tx_util/builder","title":"with_asset_of_tx_input","content":"with_asset_of_tx_input(\n  input: transaction.Input,\n  asset: Value,\n) -&gt; transaction.Input\n Add asset(s) to a transaction input.","url":"tx_util/builder.html#with_asset_of_tx_input"},{"doc":"tx_util/builder","title":"add_tx_output","content":"add_tx_output(\n  context: ScriptContext,\n  tx_out: transaction.Output,\n) -&gt; ScriptContext\n Push `tx_out` to `ScriptContext.transaction.outputs`\n\n Example,\n ```\n let tx_out = new_tx_output(...)\n     |&gt; attach_ref_script_to_tx_output(validator_hash)\n     |&gt; add_asset_to_tx_output(value)\n\n let ctx = after(now)\n     |&gt; build_txn_context()\n     |&gt; add_tx_output(tx_out)\n ```","url":"tx_util/builder.html#add_tx_output"},{"doc":"tx_util/builder","title":"new_tx_output","content":"new_tx_output(\n  address: Address,\n  lovelace: Int,\n  datum: Datum,\n) -&gt; transaction.Output\n Construct a transaction output.","url":"tx_util/builder.html#new_tx_output"},{"doc":"tx_util/builder","title":"attach_ref_script_to_tx_output","content":"attach_ref_script_to_tx_output(\n  output: transaction.Output,\n  ref_script: ValidatorHash,\n) -&gt; transaction.Output\n Attach a reference script to a transaction output.","url":"tx_util/builder.html#attach_ref_script_to_tx_output"},{"doc":"tx_util/builder","title":"add_asset_to_tx_output","content":"add_asset_to_tx_output(\n  output: transaction.Output,\n  asset: Value,\n) -&gt; transaction.Output\n Add asset(s) to a transaction output.","url":"tx_util/builder.html#add_asset_to_tx_output"},{"doc":"tx_util/builder","title":"add_certificate","content":"add_certificate(\n  context: ScriptContext,\n  certificate: Certificate,\n) -&gt; ScriptContext\n Push `certificate` to `ScriptContext.transaction.certificates`","url":"tx_util/builder.html#add_certificate"},{"doc":"tx_util/builder","title":"set_withdrawals","content":"set_withdrawals(\n  context: ScriptContext,\n  withdrawals: Pairs&lt;Credential, Lovelace&gt;,\n) -&gt; ScriptContext\n Set `withdrawals` to `ScriptContext.transaction.withdrawals`","url":"tx_util/builder.html#set_withdrawals"},{"doc":"tx_util/builder","title":"insert_withdrawal","content":"insert_withdrawal(\n  context: ScriptContext,\n  withdrawal_key: Credential,\n  withdrawal_value: Lovelace,\n  withdrawal_compare: fn(Credential, Credential) -&gt; Ordering,\n) -&gt; ScriptContext\n Insert `withdrawal` to `ScriptContext.transaction.withdrawals`","url":"tx_util/builder.html#insert_withdrawal"},{"doc":"tx_util/builder","title":"set_redeemers","content":"set_redeemers(\n  context: ScriptContext,\n  redeemers: Pairs&lt;ScriptPurpose, Redeemer&gt;,\n) -&gt; ScriptContext\n Set `redeemers` to `ScriptContext.transaction.redeemers`","url":"tx_util/builder.html#set_redeemers"},{"doc":"tx_util/builder","title":"insert_redeemer","content":"insert_redeemer(\n  context: ScriptContext,\n  redeemer_key: ScriptPurpose,\n  redeemer_value: Redeemer,\n  redeemer_compare: fn(ScriptPurpose, ScriptPurpose) -&gt; Ordering,\n) -&gt; ScriptContext\n Insert `redeemer` to `ScriptContext.transaction.redeemers`","url":"tx_util/builder.html#insert_redeemer"},{"doc":"tx_util/builder","title":"set_datums","content":"set_datums(\n  context: ScriptContext,\n  datums: Dict&lt;ByteArray, Data&gt;,\n) -&gt; ScriptContext\n Set `datums` from `ScriptContext.transaction.datums`","url":"tx_util/builder.html#set_datums"},{"doc":"tx_util/builder","title":"set_fee","content":"set_fee(context: ScriptContext, fee: Lovelace) -&gt; ScriptContext\n Set `ScriptContext.transaction.fee`","url":"tx_util/builder.html#set_fee"},{"doc":"tx_util/builder","title":"tx_util/builder","content":" Usage example,\n ```\n test validate_something() {\n   // Arrange:\n   let nft = from_asset(&quot;NftPolicy&quot;, &quot;NftName&quot;, 1)\n   let token = from_asset(&quot;TokenPolicy&quot;, &quot;TokenName&quot;, 10)\n   // use aiken/transaction/value.{from_asset}\n   let asset_1 = from_asset(&quot;AssetPolicy1&quot;, &quot;AssetName1&quot;, 1)\n   let asset_2 = from_asset(&quot;AssetPolicy2&quot;, &quot;AssetName2&quot;, 1000)\n   let asset_2_partial = from_asset(&quot;AssetPolicy2&quot;, &quot;AssetName2&quot;, 100)\n\n   // tx_util/builder:\n   let tx_ref_in = new_tx_input(\n       &quot;TxRefInHash&quot;,                       // tx_hash: Hash&lt;Blake2b_256, Transaction&gt;\n       from_verification_key(&quot;PubKeyHash&quot;), // address: use aiken/transaction/credential\n       user_ada,                            // lovelace: Int\n       NoDatum,                             // datum: use aiken/transaction.{NoDatum}\n     ) |&gt; with_asset_of_tx_input(token)\n\n   let tx_in = new_tx_input(\n       &quot;TxInHash&quot;,                          // tx_hash: Hash&lt;Blake2b_256, Transaction&gt;\n       from_script(&quot;ValidatorHash&quot;),        // address: use aiken/transaction/credential\n       input_ada,                           // lovelace: Int\n       InlineDatum(old_datum),              // datum: use aiken/transaction.{InlineDatum}\n     ) |&gt; with_asset_of_tx_input(nft)\n       |&gt; with_asset_of_tx_input(asset_1)\n       |&gt; with_asset_of_tx_input(asset_2)\n\n   let tx_out = new_tx_output(\n       from_script(&quot;ValidatorHash&quot;),        // address: use aiken/transaction/credential\n       output_ada,                          // lovelace: Int\n       InlineDatum(new_datum),              // datum: use aiken/transaction.{InlineDatum}\n     ) |&gt; add_asset_to_tx_output(nft)\n       |&gt; add_asset_to_tx_output(asset_1)\n       |&gt; add_asset_to_tx_output(asset_2_partial)\n\n   let ctx = empty\n       |&gt; build_txn_context()\n       |&gt; add_tx_ref_input(tx_ref_in)\n       |&gt; add_tx_input(tx_in)\n       |&gt; add_tx_output(tx_out)\n       |&gt; add_signatory(&quot;PubKeyHash&quot;)\n\n   // Assert:\n   !validator.validate(script_arg_1, script_arg_2, datum, redeemer, ctx)\n }\n ```","url":"tx_util/builder.html"},{"doc":"tx_util/builder/txn","title":"set_id","content":"set_id(tx: Transaction, id: TransactionId) -&gt; Transaction\n Set `Transaction.id`.\n The default value is `#&quot;0000000000000000000000000000000000000000000000000000000000000000&quot;`","url":"tx_util/builder/txn.html#set_id"},{"doc":"tx_util/builder/txn","title":"set_validity_range","content":"set_validity_range(\n  tx: Transaction,\n  validity_range: ValidityRange,\n) -&gt; Transaction\n Set `Transaction.validity_range`","url":"tx_util/builder/txn.html#set_validity_range"},{"doc":"tx_util/builder/txn","title":"set_fee","content":"set_fee(tx: Transaction, fee: assets.Lovelace) -&gt; Transaction\n Set `Transaction.fee`","url":"tx_util/builder/txn.html#set_fee"},{"doc":"tx_util/builder/txn","title":"add_tx_input","content":"add_tx_input(tx: Transaction, tx_in: transaction.Input) -&gt; Transaction\n Concat `tx_in` to `Transaction.inputs`.\n The new `tx_in` is placed at the end of the list.\n\n Example,\n ```\n let tx_in = new_tx_input(...)\n     |&gt; set_datum_of_tx_input(...)\n     |&gt; attach_ref_script_to_tx_input(...)\n     |&gt; with_asset_of_tx_input(...)\n     |&gt; with_asset_of_tx_input(...)\n\n let txn = transaction.placeholder\n     |&gt; add_tx_input(tx_in)\n ```","url":"tx_util/builder/txn.html#add_tx_input"},{"doc":"tx_util/builder/txn","title":"new_tx_input","content":"new_tx_input(\n  output_reference: OutputReference,\n  address: Address,\n) -&gt; transaction.Input\n Initialize a transaction input with zero assets value, no datum, and no reference script.\n\n Example,\n ```\n let output_reference = OutputReference(#&quot;0000000000000000000000000000000000000000000000000000000000000064&quot;, 0)\n let address = from_verification_key(#&quot;00000000000000000000000000000000000000000000000000000056&quot;)\n\n let tx_in = new_tx_input(output_reference, address)\n ```","url":"tx_util/builder/txn.html#new_tx_input"},{"doc":"tx_util/builder/txn","title":"with_asset_of_tx_input","content":"with_asset_of_tx_input(\n  input: transaction.Input,\n  asset: assets.Value,\n) -&gt; transaction.Input\n Add asset(s) to a transaction input.\n\n Example,\n ```\n let tx_in = new_tx_input(output_reference, address)\n     |&gt; with_asset_of_tx_input(from_lovelace(2_000_000))\n     |&gt; with_asset_of_tx_input(from_asset(&quot;PolicyId1&quot;, &quot;Nft1&quot;, 1))\n     |&gt; with_asset_of_tx_input(from_asset(&quot;PolicyId1&quot;, &quot;Token1&quot;, 3_000))\n     |&gt; with_asset_of_tx_input(from_asset(&quot;PolicyId2&quot;, &quot;Nft2&quot;, 1))\n ```","url":"tx_util/builder/txn.html#with_asset_of_tx_input"},{"doc":"tx_util/builder/txn","title":"set_datum_of_tx_input","content":"set_datum_of_tx_input(\n  input: transaction.Input,\n  datum: transaction.Datum,\n) -&gt; transaction.Input\n Set the datum of a transaction input.\n\n Example,\n ```\n let tx_in = new_tx_input(output_reference, address)\n     |&gt; set_datum_of_tx_input(InlineDatum(...))\n ```","url":"tx_util/builder/txn.html#set_datum_of_tx_input"},{"doc":"tx_util/builder/txn","title":"attach_ref_script_to_tx_input","content":"attach_ref_script_to_tx_input(\n  input: transaction.Input,\n  ref_script: ScriptHash,\n) -&gt; transaction.Input\n Attach a reference script to a transaction input.\n\n Example,\n ```\n let tx_in = new_tx_input(output_reference, address)\n     |&gt; attach_ref_script_to_tx_input(#&quot;00000000000000000000000000000000000000000000000000000056&quot;)\n ```","url":"tx_util/builder/txn.html#attach_ref_script_to_tx_input"},{"doc":"tx_util/builder/txn","title":"remove_ref_script_from_tx_input","content":"remove_ref_script_from_tx_input(input: transaction.Input) -&gt; transaction.Input\n Remove reference script from a transaction input.\n\n Example,\n ```\n let tx_in = new_tx_input(output_reference, address)\n     |&gt; attach_ref_script_to_tx_input(#&quot;00000000000000000000000000000000000000000000000000000056&quot;)\n     |&gt; remove_ref_script_from_tx_input()\n ```","url":"tx_util/builder/txn.html#remove_ref_script_from_tx_input"},{"doc":"tx_util/builder/txn","title":"add_tx_ref_input","content":"add_tx_ref_input(tx: Transaction, tx_ref_in: transaction.Input) -&gt; Transaction\n Concat `tx_ref_in` to `Transaction.reference_inputs`.\n The new `tx_ref_in` is placed at the end of the list.\n\n Example,\n ```\n let tx_ref_in = new_tx_input(...)\n     |&gt; set_datum_of_tx_input(...)\n     |&gt; attach_ref_script_to_tx_input(...)\n     |&gt; with_asset_of_tx_input(...)\n     |&gt; with_asset_of_tx_input(...)\n\n let txn = transaction.placeholder\n     |&gt; add_tx_ref_input(tx_ref_in)\n ```","url":"tx_util/builder/txn.html#add_tx_ref_input"},{"doc":"tx_util/builder/txn","title":"add_tx_output","content":"add_tx_output(tx: Transaction, tx_out: transaction.Output) -&gt; Transaction\n Concat `tx_out` to `Transaction.outputs`.\n The new `tx_out` is placed at the end of the list.\n\n Example,\n ```\n let tx_out = new_tx_output(...)\n     |&gt; set_datum_of_tx_output(...)\n     |&gt; attach_ref_script_to_tx_output(...)\n     |&gt; add_asset_to_tx_output(...)\n     |&gt; add_asset_to_tx_output(...)\n\n let txn = transaction.placeholder\n     |&gt; add_tx_output(tx_out)\n ```","url":"tx_util/builder/txn.html#add_tx_output"},{"doc":"tx_util/builder/txn","title":"new_tx_output","content":"new_tx_output(address: Address) -&gt; transaction.Output\n Initialize a transaction output with zero assets value, no datum, and no reference script.\n\n Example,\n ```\n let address = from_script(#&quot;00000000000000000000000000000000000000000000000000000056&quot;)\n let tx_out = new_tx_output(address)\n ```","url":"tx_util/builder/txn.html#new_tx_output"},{"doc":"tx_util/builder/txn","title":"add_asset_to_tx_output","content":"add_asset_to_tx_output(\n  output: transaction.Output,\n  asset: assets.Value,\n) -&gt; transaction.Output\n Add asset(s) to a transaction output.\n\n Example,\n ```\n let tx_out = new_tx_output(address)\n     |&gt; add_asset_to_tx_output(from_lovelace(2_000_000))\n     |&gt; add_asset_to_tx_output(from_asset(&quot;PolicyId1&quot;, &quot;Nft1&quot;, 1))\n     |&gt; add_asset_to_tx_output(from_asset(&quot;PolicyId1&quot;, &quot;Token1&quot;, 3_000))\n     |&gt; add_asset_to_tx_output(from_asset(&quot;PolicyId2&quot;, &quot;Nft2&quot;, 1))\n ```","url":"tx_util/builder/txn.html#add_asset_to_tx_output"},{"doc":"tx_util/builder/txn","title":"set_datum_of_tx_output","content":"set_datum_of_tx_output(\n  output: transaction.Output,\n  datum: transaction.Datum,\n) -&gt; transaction.Output\n Set the datum of a transaction output.\n\n Example,\n ```\n let tx_out = new_tx_output(address)\n     |&gt; set_datum_of_tx_output(InlineDatum(...))\n ```","url":"tx_util/builder/txn.html#set_datum_of_tx_output"},{"doc":"tx_util/builder/txn","title":"attach_ref_script_to_tx_output","content":"attach_ref_script_to_tx_output(\n  output: transaction.Output,\n  ref_script: ScriptHash,\n) -&gt; transaction.Output\n Attach a reference script to a transaction output.\n\n Example,\n ```\n let tx_out = new_tx_output(address)\n     |&gt; attach_ref_script_to_tx_output(#&quot;00000000000000000000000000000000000000000000000000000056&quot;)\n ```","url":"tx_util/builder/txn.html#attach_ref_script_to_tx_output"},{"doc":"tx_util/builder/txn","title":"remove_ref_script_from_tx_output","content":"remove_ref_script_from_tx_output(\n  output: transaction.Output,\n) -&gt; transaction.Output\n Remove reference script from a transaction output.\n\n Example,\n ```\n let tx_out = new_tx_output(address)\n     |&gt; attach_ref_script_to_tx_output(#&quot;00000000000000000000000000000000000000000000000000000056&quot;)\n     |&gt; remove_ref_script_from_tx_output()\n ```","url":"tx_util/builder/txn.html#remove_ref_script_from_tx_output"},{"doc":"tx_util/builder/txn","title":"add_mint","content":"add_mint(tx: Transaction, asset: assets.Value) -&gt; Transaction\n Merge `asset` to `Transaction.mint`","url":"tx_util/builder/txn.html#add_mint"},{"doc":"tx_util/builder/txn","title":"add_certificate","content":"add_certificate(tx: Transaction, certificate: Certificate) -&gt; Transaction\n Concat `certificate` to `Transaction.certificates`.\n The new value is placed at the end of the list.","url":"tx_util/builder/txn.html#add_certificate"},{"doc":"tx_util/builder/txn","title":"add_withdrawal","content":"add_withdrawal(\n  tx: Transaction,\n  withdrawal_key: address.Credential,\n  withdrawal_value: assets.Lovelace,\n) -&gt; Transaction\n Merge `withdrawal` to `Transaction.withdrawals`","url":"tx_util/builder/txn.html#add_withdrawal"},{"doc":"tx_util/builder/txn","title":"add_signatory","content":"add_signatory(tx: Transaction, signatory: VerificationKeyHash) -&gt; Transaction\n Concat `signatory` to `Transaction.extra_signatories`.\n The new value is placed at the end of the list.","url":"tx_util/builder/txn.html#add_signatory"},{"doc":"tx_util/builder/txn","title":"add_datum","content":"add_datum(\n  tx: Transaction,\n  datum_key: DataHash,\n  datum_value: Data,\n) -&gt; Transaction\n Insert `datum` to `Transaction.datums`.\n If the key already exists, its value is overridden.","url":"tx_util/builder/txn.html#add_datum"},{"doc":"tx_util/builder/txn","title":"add_redeemer","content":"add_redeemer(\n  tx: Transaction,\n  redeemer_key: ScriptPurpose,\n  redeemer_value: transaction.Redeemer,\n) -&gt; Transaction\n Repsert `redeemer` to `Transaction.redeemers`.\n If the key already exists, its value is replaced.","url":"tx_util/builder/txn.html#add_redeemer"},{"doc":"tx_util/builder/txn","title":"add_vote","content":"add_vote(\n  tx: Transaction,\n  vote_key: governance.Voter,\n  vote_value: Pairs&lt;GovernanceActionId, governance.Vote&gt;,\n) -&gt; Transaction\n Repsert `vote` to `Transaction.votes`.\n If the key already exists, its value is replaced.","url":"tx_util/builder/txn.html#add_vote"},{"doc":"tx_util/builder/txn","title":"add_proposal_procedure","content":"add_proposal_procedure(\n  tx: Transaction,\n  deposit: assets.Lovelace,\n  return_address: address.Credential,\n  governance_action: GovernanceAction,\n) -&gt; Transaction\n Concat `proposal_procedure` to `Transaction.proposal_procedures`.\n The new value is placed at the end of the list.","url":"tx_util/builder/txn.html#add_proposal_procedure"},{"doc":"tx_util/builder/txn","title":"set_current_treasury_amount","content":"set_current_treasury_amount(\n  tx: Transaction,\n  amount: assets.Lovelace,\n) -&gt; Transaction\n Set `Transaction.current_treasury_amount`","url":"tx_util/builder/txn.html#set_current_treasury_amount"},{"doc":"tx_util/builder/txn","title":"unset_current_treasury_amount","content":"unset_current_treasury_amount(tx: Transaction) -&gt; Transaction\n Unset `Transaction.current_treasury_amount`","url":"tx_util/builder/txn.html#unset_current_treasury_amount"},{"doc":"tx_util/builder/txn","title":"set_treasury_donation","content":"set_treasury_donation(tx: Transaction, donation: assets.Lovelace) -&gt; Transaction\n Set `Transaction.treasury_donation`","url":"tx_util/builder/txn.html#set_treasury_donation"},{"doc":"tx_util/builder/txn","title":"unset_treasury_donation","content":"unset_treasury_donation(tx: Transaction) -&gt; Transaction\n Unset `Transaction.treasury_donation`","url":"tx_util/builder/txn.html#unset_treasury_donation"},{"doc":"tx_util/builder/txn","title":"tx_util/builder/txn","content":" Usage example,\n ```\n ```","url":"tx_util/builder/txn.html"}]);