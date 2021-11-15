/** * SPDX-License-Identifier: MIT */

import FungibleToken from "../contracts/FungibleToken.cdc"
import NftlyToken from "../contracts/NftlyToken.cdc"

// This transaction is a template for a transaction
// to add a Vault resource to their account
// so that they can use the NftlyToken

transaction {

    prepare(signer: AuthAccount) {

        if signer.borrow<&NftlyToken.Vault>(from: NftlyToken.VaultStoragePath) == nil {
            // Create a new NftlyToken Vault and put it in storage
            signer.save(<-NftlyToken.createEmptyVault(), to: NftlyToken.VaultStoragePath)

            // Create a public capability to the Vault that only exposes
            // the deposit function through the Receiver interface
            signer.link<&NftlyToken.Vault{FungibleToken.Receiver}>(
                NftlyToken.ReceiverPublicPath,
                target: NftlyToken.VaultStoragePath
            )

            // Create a public capability to the Vault that only exposes
            // the balance field through the Balance interface
            signer.link<&NftlyToken.Vault{FungibleToken.Balance}>(
                NftlyToken.BalancePublicPath,
                target: NftlyToken.VaultStoragePath
            )
        }
    }
}