--- A dead simple timing module by vessyk
-- @module BindMe
local SimpleTimer = {}

--- Constructor
function SimpleTimer:New()
	local newInstance = {}
	setmetatable(newInstance, self)
	self.__index = self

	return newInstance
end

SimpleTimer.currentHandles = {}

--- Callback after period elapse
-- @param name timer name. Must be unique!
-- @param period in seconds
-- @param callback function
function SimpleTimer:After(name, period, callback, callbackObject)
	self.currentHandles[name] = {
		period = period,
		callback = callback,
		callbackObject = callbackObject,
		currentProgress = 0,
		ending = false,
		type = 0
	}
end

--- Callback during period
-- @param name timer name. Must be unique!
-- @param period in seconds
-- @param callback during period
-- @param endedcallback callback after end
function SimpleTimer:During(name, period, callback, callbackObject, endedcallback)
	endedcallback = endedcallback or nil
	self.currentHandles[name] = {
		period = period,
		callback = callback,
		callbackObject = callbackObject,
		endedcallback = endedcallback,
		currentProgress = 0,
		ending = false,
		type = 1
	}
end

--- Calllback every period
-- @param name timer name. Must be unique!
-- @param period in seconds
-- @param frequence in seconds
-- @param callback every frequence during period
-- @param endedcallback callback after end
function SimpleTimer:Every(name, period, frequence, callback, callbackObject, endedcallback)
	endedcallback = endedcallback or nil
	self.currentHandles[name] = {
		period = period,
		callback = callback,
		callbackObject = callbackObject,
		frequence = frequence,
		endedcallback = endedcallback,
		currentProgress = 0,
		ending = false,
		type = 2,
		currentFrequenceProgress = 0
	}
end

--- Update from LOVE
-- @param deltaTime dt
function SimpleTimer:Update(deltaTime)
	for key, value in pairs(self.currentHandles) do
		if (value.ending == false) then
			value.currentProgress = value.currentProgress + deltaTime

			-- 0 = after timer
			if (value.type == 0) then
				if value.currentProgress >= value.period then
					value.ending = true
					value.callback(value.callbackObject or nil)
					self.currentHandles[key] = nil
				end
				-- 1 = during timer
			elseif (value.type == 1) then
				if value.currentProgress >= value.period then
					value.ending = true

					value.callback(value.callbackObject or nil)

					-- callback when during timer ending
					if (value.endedcallback ~= nil) then
						value.endedcallback()
					end

					self.currentHandles[key] = nil
				else
					-- callback during period
					value.callback(value.callbackObject or nil)
				end
				-- 2 = "every" timer
			elseif (value.type == 2) then
				if value.currentProgress >= value.period then
					value.ending = true

					value.callback(value.callbackObject or nil)

					-- callback when during timer ending
					if (value.endedcallback ~= nil) then
						value.endedcallback()
					end

					self.currentHandles[key] = nil
				else
					value.currentFrequenceProgress = value.currentFrequenceProgress + deltaTime
					if (value.currentFrequenceProgress >= value.frequence) then
						-- callback after frequence
						value.callback(value.callbackObject or nil)
						value.currentFrequenceProgress = 0
					end
				end
			end

		end
	end
end

return SimpleTimer
