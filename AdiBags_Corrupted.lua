--[[
AdiBags_Lowlevel - Adds Lowlevel filters to AdiBags.
Copyright 2016 seirl
All rights reserved.
--]]

local _, ns = ...

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
local L = setmetatable({}, {__index = addon.L})

do -- Localization
	L['Corrupted Items'] = 'Corrupted Items'
	L['Corrupted'] = 'Corrupted'
	L['Corruption'] = 'Corruption'

  local locale = GetLocale()
  if locale == "frFR" then

  elseif locale == "deDE" then
    L['Corrupted Items'] = 'Verderbte Gegenstände'
    L['Corrupted'] = 'Verderbt'
    L['Corruption'] = 'Verderbnis'
  
  elseif locale == "esMX" then
	
  elseif locale == "ruRU" then
	
  elseif locale == "esES" then
	
  elseif locale == "zhTW" then
	
  elseif locale == "zhCN" then
	
  elseif locale == "koKR" then
	
  end
end


local tooltip
local function create()
  local tip, leftside = CreateFrame("GameTooltip"), {}
  for i = 1,15 do
    local L,R = tip:CreateFontString(), tip:CreateFontString()
    L:SetFontObject(GameFontNormal)
    R:SetFontObject(GameFontNormal)
    tip:AddFontStrings(L,R)
    leftside[i] = L
  end
  tip.leftside = leftside
  return tip
end

-- The filter itself

local setFilter = addon:RegisterFilter("Corrupted", 67, 'ABEvent-1.0')
setFilter.uiName = L['Corrupted']
setFilter.uiDesc = L['Put corrupted items in their own section.']
local corruptionTooltipPattern = "(%d+) " .. L["Corruption"]

function setFilter:OnInitialize()
  self.db = addon.db:RegisterNamespace('Corrupted', {
    profile = { enable = true, level = 800 },
    char = {  },
  })
end

function setFilter:Update()
  self:SendMessage('AdiBags_FiltersChanged')
end

function setFilter:OnEnable()
  addon:UpdateFilters()
end

function setFilter:OnDisable()
  addon:UpdateFilters()
end

local setNames = {}

function setFilter:Filter(slotData)
  tooltip = tooltip or create()
  tooltip:SetOwner(UIParent,"ANCHOR_NONE")
  tooltip:ClearLines()

  if slotData.bag == BANK_CONTAINER then
    tooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slotData.slot, nil))
  else
    tooltip:SetBagItem(slotData.bag, slotData.slot)
  end

  for i = 1,15 do
    local t = tooltip.leftside[i]:GetText()
    if t ~= nil then
      -- local m = t:match("^+(%d+) (Corruption)?(Verderbnis)?$")
      local m = t:match(corruptionTooltipPattern)
      if self.db.profile.enable and m ~= nil then -- and tonumber(m) < self.db.profile.level then
        return L['Corrupted']
      end
    end
  end
  tooltip:Hide()
end

function setFilter:GetOptions()
  return {
    enable = {
      name = L['Enable Corrupted'],
      desc = L['Check this if you want a section for corrupted items.'],
      type = 'toggle',
      order = 10,
    },
--    level = {
--      name = L['Item level'],
--      desc = L['Minimum item level matched'],
--      type = 'range',
--      min = 0,
--      max = 1000,
--      step = 1,
--      order = 20,
--    },
  }, addon:GetOptionHandler(self, false, function() return self:Update() end)
end
