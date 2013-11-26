LuaEco - Design of a Lua Ecosystem (proposal)
=============================================

The code and description here is my proposal to the discussion about Lua Ecosystem (see http://www.lua.org/wshop13.html#Chapuis and http://lua.2524044.n2.nabble.com/Lua-Ecosystem-td7654513.html ).

Sometimes I need a module which implements some functionality (like encoding to JSON), and I don't care what the module is, but sometimes I want specific module implementation (because I know it handles UTF8 correctly, or I want pure-lua implementation).

So I as a developer want to have option to require "any" module which implements some (well defined) API (and if it was automatically discovered for me - that would be a bonus), as well as to require any specific module (known by its unique name or location).

There are some "combo" modules, which are available as one library, but they implement many different APIs.

So my proposition is to implement 4 functions:

require_url(uri) - which returns a module from any location/scheme (like luarock://dkjson or http://www.example.com/module.lua)

require_api(apiname) - which returns a module implementing required API

find_api_providers(apiname) - which returns a table of all known modules implementing given api

choose_module(TModules) - which returns at most one module, based on "local preferences"

The last two functions could be overwritten by the user/site admin, so the source of API definitions and modules list could be changed (from "official site" to "alternative community site" or "local files"), and the algorithm for choosing the module from a list of available options could be customized.

Then there are 2 sources of data APITREE and MODULES.

APITREE is a tree of "official" API definitions, i.e. for each entry there is a list of functions (their names and arguments) and unit tests for checking implementations. That would be based on libraries from other languages, like:
http://www.ruby-doc.org/stdlib-2.0.0/packages.html
http://docs.oracle.com/javase/6/docs/api/
http://perldoc.perl.org/perlmodlib.html#Standard-Modules
etc.

MODULES would list each module, with following data:
- module name
- module location
- a list of API implemented
- optionally, a map list for each API (where the local function name differs from the official name)

So the Lua community could focus on design of APITREE (tree organization, function names and their arguments and return values) and implementation of unit tests, and the module authors could follow official API when implementing their new module.

Note that if all the official APITREE functions had their unit tests implemented, that woulkd allow automatic module discovery, by checking each known module against each known official API.

Check sample (runnable! - you need luarocks, then luasocket and nixio rocks installed) implementation in *.lua files.



