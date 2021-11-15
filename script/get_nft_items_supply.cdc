import Nftly from "../contracts/Nftly.cdc"

// This scripts returns the number of KittyItems currently in existence.

pub fun main(): UInt64 {
    return Nftly.totalSupply
}