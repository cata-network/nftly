#!/usr/bin/env python3
#coding=utf-8
#########################################################################
# Author: @maris
# Created Time: May 18  2017 18:55:41 PM CST
# File Name:test_token.py
# Description:封装flow cli
# SPDX-License-Identifier: MIT
#########################################################################
import sys
import re
import json
import time
import io
import os
import flow_account


config = "flow.json"
#附属参数
PARAM = " -o json -n testnet -f {} --signer emulator-account ".format(config)

def test():
    com = "flow status {}".format(PARAM)
    val = os.popen(com)
    print(val.read())

"""
功能：create user token vault
输入：address， user address
返回：transaction_id
"""
def create_user_vault(address):
    # step 1,  user address in flow.josn
    user_name = "user_" + address.replace("0x", "")
    # step 2, create user nft vault
    com = 'flow transactions send ../trans/setup_account.cdc -n testnet  -o json --signer {}'.format(user_name)
    val = os.popen(com)
    result = val.read().strip()
    data = json.loads(result)
    #step 3, get transaction id
    trans_id = data["id"]
    return trans_id


"""
功能：生成nft
输入：address, sent token to this address
输入：token_num, token num 
返回：trans id
"""
def create_token(address, token_num):
    com = "flow transactions send ../trans/mint_tokens.cdc {} {} {}".format(address, token_num, PARAM)
    # print(com)
    val = os.popen(com)
    result = val.read().strip()
    data = json.loads(result)
    #print(data)
    trans_id = data["id"]
    return trans_id


"""
功能：给用户发送nft
输入：address， 用户地址
输入：token_num，token num
返回：transaction_id，交易地址
"""
def send_user_token(address, token_num):
    com = "flow transactions send ../trans/transfer_tokens.cdc {} {} {}".format(token_num, address, PARAM)
    val = os.popen(com)
    result = val.read().strip()
    data = json.loads(result)
    #print(data)
    trans_id = data["id"]
    return trans_id

"""
功能：获得用户token数据
输入：address， 用户地址
返回：用户nft id列表
"""
def get_user_token(address):
    com = 'flow scripts execute ../script/get_balance.cdc {} -o json -n testnet'.format(address)
    #print(com)
    val = os.popen(com)
    result = val.read().strip()
    data = json.loads(result)
    token_num = data["value"]
    return token_num



if __name__=="__main__":
    admin_address = "0x5e1e16ea71ac90c2"
    #user_address = "0xc82fef614497fd3e"

    #step 0, create new user
    private_key, public_key, address, transaction_id = flow_account.ini_new_user_account()
    user_address = "0x" + address
    print("0. create new flow user", user_address)

    #step 1, initial user nft vault
    trans_id = create_user_vault(user_address)
    print("1. initial user nft vault success, trans id", trans_id)

    #step 2, mint token, for admin
    token_num = 15.0 #must add .o
    trans_id = create_token(admin_address, token_num)
    print("2. create", token_num,"token success,transaction id is ", trans_id)

    #step 3, send token to user
    token_num = 11.2 #float
    trans_id = send_user_token(user_address, token_num)
    print("3. send ", token_num,"token success,transaction id is ", trans_id)

    #step 4, get user token num
    token_num = get_user_token(user_address)
    print("user has token:", token_num)





