local Charset = {}

for i = 48, 57 do
    table.insert(Charset, string.char(i))
end
for i = 65, 90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end

VNCore.Math = {}

function VNCore.DumpTable(table, nb)
    if nb == nil then
        nb = 0
    end

    if type(table) == "table" then
        local s = ""
        for _ = 1, nb + 1, 1 do
            s = s .. "    "
        end

        s = "{\n"
        for k, v in pairs(table) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            for _ = 1, nb, 1 do
                s = s .. "    "
            end
            s = s .. "[" .. k .. "] = " .. VNCore.DumpTable(v, nb + 1) .. ",\n"
        end

        for _ = 1, nb, 1 do
            s = s .. "    "
        end

        return s .. "}"
    else
        return tostring(table)
    end
end

function VNCore.GetRandomString(length)
    math.randomseed(GetGameTimer())

    return length > 0 and VNCore.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)] or ""
end

function VNCore.Round(value, numDecimalPlaces)
    return VNCore.Math.Round(value, numDecimalPlaces)
end

function VNCore.ValidateType(value, ...)
    local types = { ... }
    if #types == 0 then return true end

    local mapType = {}
    for i = 1, #types, 1 do
        local validateType = types[i]
        assert(type(validateType) == "string", "bad argument types, only expected string") -- should never use anyhing else than string
        mapType[validateType] = true
    end

    local valueType = type(value)

    local matches = mapType[valueType] ~= nil

    if not matches then
        local requireTypes = table.concat(types, " or ")
        local errorMessage = ("bad value (%s expected, got %s)"):format(requireTypes, valueType)

        return false, errorMessage
    end

    return true
end

function VNCore.AssertType(...)
    local matches, errorMessage = VNCore.ValidateType(...)

    assert(matches, errorMessage)

    return matches
end

function VNCore.IsFunctionReference(val)
    local typeVal = type(val)

    return typeVal == "function" or (typeVal == "table" and type(getmetatable(val)?.__call) == "function")
end

function VNCore.Await(conditionFunc, errorMessage, timeoutMs)
    timeoutMs = timeoutMs or 1000

    if timeoutMs < 0 then
        error("Timeout should be a positive number.")
    end

    if not VNCore.IsFunctionReference(conditionFunc) then
        error("Condition Function should be a function reference.")
    end

    -- since errorMessage is optional, we only validate it if the user provided it.
    if errorMessage then
        VNCore.AssertType(errorMessage, "string", "errorMessage should be a string.")
    end

    local invokingResource = GetInvokingResource()
    local startTimeMs = GetGameTimer()
    while GetGameTimer() - startTimeMs < timeoutMs do
        local result = conditionFunc()

        if result then
            return true, result
        end

        Wait(0)
    end

    if errorMessage then
        error(("[%s] -> %s"):format(invokingResource, errorMessage))
    end

    return false
end