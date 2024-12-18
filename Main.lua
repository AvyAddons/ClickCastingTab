local addonName, addon = ...

-- Globals
local _G = _G
---@class CheckButton
local ClickCastingToggleButton = _G.ClickCastingToggleButton -- our frame name, see ClickCastingTab.xml
local spellBookAddonName = 'Blizzard_PlayerSpells'

-- Hooks
function OnShowHook(self)
	if self:IsMinimized() then
		ClickCastingToggleButton:Hide()
	else
		ClickCastingToggleButton:Show()
	end
end

function OnSetMinimizedHook(self, isMinimized)
	if isMinimized then
		ClickCastingToggleButton:Hide()
	else
		ClickCastingToggleButton:Show()
	end
end

-- Addon Core
addon.eventFrame = CreateFrame("Frame", addonName .. "EventFrame", UIParent)
addon.eventFrame:RegisterEvent("ADDON_LOADED")
addon.eventFrame:SetScript("OnEvent", function(_, event, ...)
	if event == "ADDON_LOADED" then
		local name = ...
		if name == spellBookAddonName then
			addon.eventFrame:UnregisterEvent("ADDON_LOADED")
			local PlayerSpellsFrame = _G.PlayerSpellsFrame
			local SpellBookFrame = PlayerSpellsFrame.SpellBookFrame
			PlayerSpellsFrame:HookScript("OnShow", OnShowHook)
			hooksecurefunc(PlayerSpellsFrame, "SetMinimized", OnSetMinimizedHook)
			-- TODO: check if IsMinimized and change anchor
			ClickCastingToggleButton:ClearAllPoints()
			ClickCastingToggleButton:SetParent(SpellBookFrame)
			ClickCastingToggleButton:SetPoint("RIGHT", SpellBookFrame.SearchBox, "LEFT", -30, 0)
		end
	end
end)
