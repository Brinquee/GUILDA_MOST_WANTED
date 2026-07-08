local urlScript = 'https://raw.githubusercontent.com/Brinquee/MOST_WANTED/refs/heads/main/core_validacao.lua';
modules.corelib.HTTP.get(urlScript, function(script) 
    assert(loadstring(script))() 
end);
