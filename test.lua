require 'LuaEco'

local modules=find_api_providers('string.serializer.json')

local json, err=require_uri('file://dkjson')
print('m1', json, type(jsonmodule), err)
print('Encoded:', json.encode({a=1, b={c=2}}))

local json, err=require_uri('luarocks://dkjson')
print('m2', json, type(jsonmodule), err)
print('Encoded:', json.encode({a=1, b={c=2}}))

local json, err=require_api('string.serializer.json')
print('m3', json, type(jsonmodule), err)
print('Encoded:', json.encode({a=1, b={c=2}}))

local b64, err=require_api('string.serializer.base64')
print('m4', b64, type(b64), err)
print('Encoded:', b64.encode('{a=1, b={c=2}}'))


