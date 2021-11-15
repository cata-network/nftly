/** * SPDX-License-Identifier: MIT */

import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import Nftly from "../contracts/Nftly.cdc"

// This transaction configures an account to hold Nftly.

transaction {
    prepare(signer: AuthAccount) {
        // if the account doesn't already have a collection
        if signer.borrow<&Nftly.Collection>(from: Nftly.CollectionStoragePath) == nil {

            // create a new empty collection
            let collection <- Nftly.createEmptyCollection()

            // save it to the account
            signer.save(<-collection, to: Nftly.CollectionStoragePath)

            // create a public capability for the collection
            signer.link<&Nftly.Collection{NonFungibleToken.CollectionPublic, Nftly.NftlyCollectionPublic}>(Nftly.CollectionPublicPath, target: Nftly.CollectionStoragePath)
        }
    }
}