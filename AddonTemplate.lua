local addonName, ns = ...

local L = setmetatable({}, {__index=function(t,i) return i end})
local defaults, defaultsPC, db, dbpc = {}, {}


local function Print(...) print("|cFF33FF99"..addonName.."|r:", ...) end
local debugf = tekDebug and tekDebug:GetFrame(addonName)
local function Debug(...) if debugf then debugf:AddMessage(string.join(", ", tostringall(...))) end end

local f = CreateFrame("frame")
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
f:RegisterEvent("ADDON_LOADED")

function f:ADDON_LOADED(event, addon)
	if addon ~= addonName then return end

	-- Setup Database
	_G[addonName.."DB"] = setmetatable(_G[addonName.."DB"] or {}, {__index = defaults})
	db = _G[addonName.."DB"]
	_G[addonName.."DBPC"] = setmetatable(_G[addonName.."DBPC"] or {}, {__index = defaultsPC})
	dbpc = _G[addonName.."DBPC"]

	-- Do anything you need to do after addon has loaded

	LibStub("tekKonfig-AboutPanel").new(nil, addonName) -- Make first arg nil if no parent config panel
	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil
	if IsLoggedIn() then self:PLAYER_LOGIN() else self:RegisterEvent("PLAYER_LOGIN") end
end


function f:PLAYER_LOGIN()
	self:RegisterEvent("PLAYER_LOGOUT")

	-- Do anything you need to do after the player has entered the world

	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end


function f:PLAYER_LOGOUT()
	for i,v in pairs(defaults) do if db[i] == v then db[i] = nil end end
	for i,v in pairs(defaultsPC) do if dbpc[i] == v then dbpc[i] = nil end end

	-- Do anything you need to do as the player logs out
end

-- Create a simple slash command for /addonName
_G["SLASH_"..string.upper(addonName).."1"] = string.lower("/"..addonName)
SlashCmdList[string.upper(addonName)] = function(msg)
	-- Do crap here
end

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:GetDataObjectByName(addonName) or ldb:NewDataObject(addonName, {type = "launcher", icon = "Interface\\Icons\\Spell_Nature_GroundingTotem"})
dataobj.OnClick = SlashCmdList.ADDONTEMPLATE

