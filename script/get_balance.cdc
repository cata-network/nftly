/** * SPDX-License-Identifier: MIT */

import FungibleToken from "../contracts/FungibleToken.cdc"
import NftlyToken from "../contracts/NftlyToken.cdc"

// This script returns an account's NftlyToken balance.

pub fun main(address: Address): UFix64 {
    let account = getAccount(address)

    let vaultRef = account.getCapability(NftlyToken.BalancePublicPath)!.borrow<&NftlyToken.Vault{FungibleToken.Balance}>()
        ?? panic("Could not borrow Balance reference to the Vault")

    return vaultRef.balance
}