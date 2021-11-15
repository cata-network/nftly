import NftlyToken from "../contracts/NftlyToken.cdc"

// This script returns the total amount of NftlyToken currently in existence.

pub fun main(): UFix64 {

    let supply = NftlyToken.totalSupply

    log(supply)

    return supply
}