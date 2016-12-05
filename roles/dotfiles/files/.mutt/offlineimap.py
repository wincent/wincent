#!/usr/bin/python

import os, subprocess, yaml

def get_keychain_pass(account=None, server=None):
    params = {
        'command': os.environ['HOME'] + '/.zsh/bin/get-keychain-pass',
        'account': account,
        'server': server,
    }
    command = "%(command)s %(account)s %(server)s" % params
    output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
    return output.strip()

def copy_ignore(text):
    blacklist = yaml.load(text)
    return lambda foldername: blacklist.get(foldername)
