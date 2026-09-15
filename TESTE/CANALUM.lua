local urlScript = '';
modules.corelib.HTTP.get(urlScript, function(script) 
     assert(loadstring(script))() 
end);
