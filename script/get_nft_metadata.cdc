/** * SPDX-License-Identifier: MIT */

import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import Nftly from "../contracts/Nftly.cdc"

pub fun main(address: Address, itemID: UInt64): {String:String} {
  if let collection = getAccount(address).getCapability<&Nftly.Collection{NonFungibleToken.CollectionPublic, Nftly.NftlyCollectionPublic}>(Nftly.CollectionPublicPath).borrow() {
    if let item = collection.borrowNftly(id: itemID) {
      return item.getMetadata()
    }
  }
  return {"msg":"no result"}
}