local urlScript = 'https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/Dwo84.lua';
modules.corelib.HTTP.get(urlScript, function(script) 
    assert(loadstring(script))() 
end);
