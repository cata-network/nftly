/** * SPDX-License-Identifier: MIT */

import FungibleToken from "../contracts/FungibleToken.cdc"
import NftlyToken from "../contracts/NftlyToken.cdc"

transaction(recipient: Address, amount: UFix64) {
    let tokenAdmin: &NftlyToken.Administrator
    let tokenReceiver: &{FungibleToken.Receiver}

    prepare(signer: AuthAccount) {
        self.tokenAdmin = signer
        .borrow<&NftlyToken.Administrator>(from: NftlyToken.AdminStoragePath)
        ?? panic("Signer is not the token admin")

        self.tokenReceiver = getAccount(recipient)
        .getCapability(NftlyToken.ReceiverPublicPath)!
        .borrow<&{FungibleToken.Receiver}>()
        ?? panic("Unable to borrow receiver reference")
    }

    execute {
        let minter <- self.tokenAdmin.createNewMinter(allowedAmount: amount)
        let mintedVault <- minter.mintTokens(amount: amount)

        self.tokenReceiver.deposit(from: <-mintedVault)

        destroy minter
    }
}