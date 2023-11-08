local addonName, addon = ...

-- Globals
local _G = _G
---@class CheckButton
local ClickCastingSkillLineTab = _G.ClickCastingSkillLineTab -- our frame name, see ClickCastingTab.xml

-- Addon Core
addon.eventFrame = CreateFrame("Frame", addonName .. "EventFrame", UIParent)
addon.eventFrame:RegisterEvent("ADDON_LOADED")
addon.eventFrame:SetScript("OnEvent", function(frame, event, ...)
	if event == "ADDON_LOADED" then
		if ... == addonName then
			addon.eventFrame:UnregisterEvent("ADDON_LOADED")
			ClickCastingSkillLineTab.tooltip = "Click Cast Bindings"
		end
	end
end)
