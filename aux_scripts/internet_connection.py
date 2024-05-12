#!/usr/bin/env python3
import os

import urllib.request

def connect(host='http://google.com'):
    try:
        urllib.request.urlopen(host) #Python 3.x
        return True
    except:
        return False

# test
print( "true" if connect() else "false" )