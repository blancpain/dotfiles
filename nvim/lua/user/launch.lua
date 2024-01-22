LAZY_PLUGIN_SPEC = {}

-- functions/vars are global by default in lua
function spec(item)
    table.insert(LAZY_PLUGIN_SPEC, {import = item})
end
