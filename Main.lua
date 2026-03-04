local addonName, addon = ...

-- Globals
local _G = _G
---@class Button
local ClickCastingToggleButton = _G.ClickCastingToggleButton -- our frame name, see ClickCastingTab.xml
local spellBookAddonName = 'Blizzard_PlayerSpells'

--- Disable the tab while the click binding frame is open
local function OnClickBindingLoaded()
	local ClickBindingFrame = _G.ClickBindingFrame
	if not ClickBindingFrame then return end
	ClickBindingFrame:HookScript("OnShow", function()
		ClickCastingToggleButton:SetEnabled(false)
		ClickCastingToggleButton:SetTabSelected(true)
	end)
	ClickBindingFrame:HookScript("OnHide", function()
		ClickCastingToggleButton:SetEnabled(true)
		ClickCastingToggleButton:SetTabSelected(false)
	end)
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

			-- Position as a bottom tab next to the existing tabs
			local tabSystem = PlayerSpellsFrame.TabSystem
			local lastTab = tabSystem.tabs[#tabSystem.tabs]
			ClickCastingToggleButton:ClearAllPoints()
			ClickCastingToggleButton:SetParent(PlayerSpellsFrame)
			ClickCastingToggleButton:SetPoint("LEFT", lastTab, "RIGHT", 1, 0)
			ClickCastingToggleButton:Show()

			-- ClickBindingFrame is load-on-demand, hook when it becomes available
			if _G.ClickBindingFrame then
				OnClickBindingLoaded()
			else
				addon.eventFrame:RegisterEvent("ADDON_LOADED")
				addon.eventFrame:HookScript("OnEvent", function(_, ev, loadedName)
					if ev == "ADDON_LOADED" and loadedName == "Blizzard_ClickBindingUI" then
						addon.eventFrame:UnregisterEvent("ADDON_LOADED")
						OnClickBindingLoaded()
					end
				end)
			end
		end
	end
end)
