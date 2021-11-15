import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import Nftly from "../contracts/Nftly.cdc"

pub struct AccountItem {
  pub let itemID: UInt64
  pub let metadata: {String:String}
  pub let resourceID: UInt64
  pub let owner: Address

  init(itemID: UInt64, metadata: {String:String}, resourceID: UInt64, owner: Address) {
    self.itemID = itemID
    self.metadata = metadata
    self.resourceID = resourceID
    self.owner = owner
  }
}

pub fun main(address: Address, itemID: UInt64): AccountItem? {
  if let collection = getAccount(address).getCapability<&Nftly.Collection{NonFungibleToken.CollectionPublic, Nftly.NftlyCollectionPublic}>(Nftly.CollectionPublicPath).borrow() {
    if let item = collection.borrowNftly(id: itemID) {
      return AccountItem(itemID: itemID, metadata: item.getMetadata(), resourceID: item.uuid, owner: address)
    }
  }
  return nil
}