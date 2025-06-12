VNCore.Math = {}

---@param value number
---@param numDecimalPlaces? number
---@return number
function VNCore.Math.Round(value, numDecimalPlaces)
    if numDecimalPlaces then
        local power = 10 ^ numDecimalPlaces
        return math.floor((value * power) + 0.5) / power
    else
        return math.floor(value + 0.5)
    end
end

-- credit http://richard.warburton.it
---@param value number
---@return string
function VNCore.Math.GroupDigits(value)
    local left, num, right = string.match(value, "^([^%d]*%d)(%d*)(.-)$")

    return left .. (num:reverse():gsub("(%d%d%d)", "%1" .. TranslateCap("locale_digit_grouping_symbol")):reverse()) .. right
end

---@param value string | number
---@return string | nil
function VNCore.Math.Trim(value)
    value = tostring(value)
    return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
end

---@param minRange number
---@param maxRange number
---@return number
function VNCore.Math.Random(minRange, maxRange)
    math.randomseed(GetGameTimer())
    return math.random(minRange or 1, maxRange or 10)
end

---@param origin vector
---@param target vector
---@return number
function VNCore.Math.GetHeadingFromCoords(origin, target)
	local dx = origin.x - target.x
    local dy = origin.y - target.y

    local heading = math.deg(math.atan(dy, dx)) + 90

    return (heading + 360) % 360
end

