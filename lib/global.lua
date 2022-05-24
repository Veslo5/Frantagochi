Global = {}
Global._container = {} -- do not touch this directly. Internal module use only.

function Global:GetGlobal(name)
    return self._container[name]
end

function Global:AddGlobal(name, object)
    self._container[name] = object
    return object
end

function Global:RemoveGlobal(name)
    self._container[name] = nil
end

function Global:require(path)
    local module = require(path)
    self._container[path] = module
    return module
end

function Global:unrequire(path, packageUnload)
    local pacUnload = packageUnload or false

    self._container[path] = nil

    -- USE WITH CAUTION
    -- this thing is kinda hacky, basically lua does not have way how to release module
    if pacUnload then
        package.loaded[path] = nil
    end
end