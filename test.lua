require 'LuaEco'

local modules=find_api_providers('string.serializer.json')
print('MO', modules)
  --{uri='http://dkjson.github.com/dkjson', name='dkjson', version='2.0', idx='bin.b64decode', map={decode='bin.b64decode', encode='bin.b64encode'}}

--local json=require_uri('com.github.dkjson')

local json, err=require_uri('file://dkjson')
print('m1', json, type(jsonmodule), err)
print('Encoded:', json.encode({a=1, b={c=2}}))

local json, err=require_uri('luarocks://dkjson')
print('m2', json, type(jsonmodule), err)
print('Encoded:', json.encode({a=1, b={c=2}}))

--local json, err=require_uri('http://dkjson.github.com/dkjson')
local json, err=require_api('string.serializer.json')
print('m3', json, type(jsonmodule), err)
print('Encoded:', json.encode({a=1, b={c=2}}))

--local json, err=require_api('string.serializer.json')
local json, err=require_api('string.serializer.base64')
print('m4', json, type(json), err)
print('Encoded:', json.encode('{a=1, b={c=2}}'))


