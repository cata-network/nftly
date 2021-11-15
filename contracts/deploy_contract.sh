#!/bin/sh
flow accounts add-contract FungibleToken ./FungibleToken.cdc -n testnet
flow accounts add-contract NonFungibleToken ./NonFungibleToken.cdc -n testnet
flow project deploy -n testnet