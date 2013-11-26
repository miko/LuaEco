-- This would be a tree of official API
local APITREE={
  string={
    serializer={
      json={description='JSON serialize/deserialize', functions={'decode', 'encode'}},
      base64={description='BASE64 serialize/deserialize', functions={'decode', 'encode'}}
    },
  },
}

-- This is a list of implementations (modules) for each official API entry
local API={
  ['string.serializer.base64']={},
  ['string.serializer.json']={},
}

-- sample API implementations
table.insert(API['string.serializer.json'], {name='dkjson', uri='http://dkolf.de/src/dkjson-lua.fsl/raw/dkjson.lua?name=0b725e9e99117b71a1f62e921c98bf3327ac8809', api={'string.serializer.json'}})
table.insert(API['string.serializer.base64'], {name='nixio', uri='luarocks://nixio', api={'string.serializer.base64'}, map={['string.serializer.base64']={decode='bin.b64decode', encode='bin.b64encode'}}})



function find_api_providers(apiname)
  return API[apiname]
end

function choose_module(TModules)
  return TModules[1]
end

function require_uri(uri)
  if uri:sub(1,7)=='file://' then
    return require (uri:sub(8))
  elseif uri:sub(1,11)=='luarocks://' then
    return require (uri:sub(12))
  elseif uri:sub(1,7)=='http://' then
    local http=require 'socket.http'
    local b, c, h=http.request(uri)
    if c==200 then
      local f, err=loadstring(b, ur)
      if f then
        return assert(f)()
      else

        return nil, 'Error loading string from '..uri..' > '..tostring(err)
      end
    else
      return nil, 'Error loading file from '..uri
    end
  else
    -- implement downloading a module from the net, caching it locally  
    error('Not implemented: '..uri)
  end
end

-- based on http://www.inf.puc-rio.br/~roberto/book/code/getfield.lua.html
local function getfield (f, T)
  local v = T or _G    -- start with the table of globals
  for w in string.gfind(f, "[%w_]+") do
    v = v[w]
  end
  return v
end

function require_api(apiname)
  local description=getfield(apiname, APITREE)
  assert(description, 'No official API registered for '..apiname)
  local TModules=find_api_providers(apiname)
  if #TModules>0 then
    local choosenModule=choose_module(TModules)
    if choosenModule then
      local implementation, err=require_uri(choosenModule.uri)
      if not implementation then
        return nil, err or 'Error: no implementation'
      end
      if choosenModule.map and choosenModule.map[apiname] then
        local proxy={}
        for k,v in pairs(choosenModule.map[apiname]) do
          proxy[k]=getfield(v, implementation)
        end
        return setmetatable(proxy, {__index=implementation})
      else
        return implementation
      end
    else
      return nil, 'No module choosen for '..apiname
    end
  else
    return nil, 'Found no modules for api: '..apiname
  end
end

