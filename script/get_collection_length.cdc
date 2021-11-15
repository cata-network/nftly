import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import Nftly from "../contracts/Nftly.cdc"

// This script returns the size of an account's Nftly collection.

pub fun main(address: Address): Int {
    let account = getAccount(address)

    let collectionRef = account.getCapability(Nftly.CollectionPublicPath)!
        .borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not borrow capability from public collection")

    return collectionRef.getIDs().length
}