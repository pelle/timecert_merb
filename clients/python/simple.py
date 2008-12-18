#!/usr/bin/env python
import hashlib, urllib

def GetHash( file ):
  digest = hashlib.sha1( open( file ).read() ).hexdigest()
  url =  '''http://timecert.org/%s.yaml'''%digest
  request = urllib.urlopen( url )
  request = request.read()
  return request

# Creating hex digest of an html file
file = '''index.html'''
request = GetHash( file )
print request