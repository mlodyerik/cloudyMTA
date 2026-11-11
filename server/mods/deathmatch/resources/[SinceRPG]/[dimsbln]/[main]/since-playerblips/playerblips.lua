  

local function loadClass()
    ---------
    -- Start of slither.lua dependency
    ---------

    local _LICENSE = -- zlib / libpng
    [[
    Copyright (c) 2011-2014 Bart van Strien

    This software is provided 'as-is', without any express or implied
    warranty. In no event will the authors be held liable for any damages
    arising from the use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

      1. The origin of this software must not be misrepresented; you must not
      claim that you wrote the original software. If you use this software
      in a product, an acknowledgment in the product documentation would be
      appreciated but is not required.

      2. Altered source versions must be plainly marked as such, and must not be
      misrepresented as being the original software.

      3. This notice may not be removed or altered from any source
      distribution.
    ]]

    local class =
    {
        _VERSION = "Slither 20140904",
        -- I have no better versioning scheme, deal with it
        _DESCRIPTION = "Slither is a pythonic class library for lua",
        _URL = "http://bitbucket.org/bartbes/slither",
        _LICENSE = _LICENSE,
    }

    local function stringtotable(path)
        local t = _G
        local name

        for part in path:gmatch("[^%.]+") do
            t = name and t[name] or t
            name = part
        end

        return t, name
    end

    local function class_generator(name, b, t)
        local parents = {}
        for _, v in ipairs(b) do
            parents[v] = true
            for _, v in ipairs(v.__parents__) do
                parents[v] = true
            end
        end

        local temp = { __parents__ = {} }
        for i, v in pairs(parents) do
            table.insert(temp.__parents__, i)
        end

        local class = setmetatable(temp, {
            __index = function(self, key)
                if key == "__class__" then return temp end
                if key == "__name__" then return name end
                if t[key] ~= nil then return t[key] end
                for i, v in ipairs(b) do
                    if v[key] ~= nil then return v[key] end
                end
                if tostring(key):match("^__.+__$") then return end
                if self.__getattr__ then
                    return self:__getattr__(key)
                end
            end,

            __newindex = function(self, key, value)
                t[key] = value
            end,

            allocate = function(instance)
                local smt = getmetatable(temp)
                local mt = {__index = smt.__index}

                function mt:__newindex(key, value)
                    if self.__setattr__ then
                        return self:__setattr__(key, value)
                    else
                        return rawset(self, key, value)
                    end
                end

                if temp.__cmp__ then
                    if not smt.eq or not smt.lt then
                        function smt.eq(a, b)
                            return a.__cmp__(a, b) == 0
                        end
                        function smt.lt(a, b)
                            return a.__cmp__(a, b) < 0
                        end
                    end
                    mt.__eq = smt.eq
                    mt.__lt = smt.lt
                end

                for i, v in pairs{
                    __call__ = "__call", __len__ = "__len",
                    __add__ = "__add", __sub__ = "__sub",
                    __mul__ = "__mul", __div__ = "__div",
                    __mod__ = "__mod", __pow__ = "__pow",
                    __neg__ = "__unm", __concat__ = "__concat",
                    __str__ = "__tostring",
                    } do
                    if temp[i] then mt[v] = temp[i] end
                end

                return setmetatable(instance or {}, mt)
            end,

            __call = function(self, ...)
                local instance = getmetatable(self).allocate()
                if instance.__init__ then instance:__init__(...) end
                return instance
            end
            })

        for i, v in ipairs(t.__attributes__ or {}) do
            class = v(class) or class
        end

        return class
    end

    local function inheritance_handler(set, name, ...)
        local args = {...}

        for i = 1, select("#", ...) do
            if args[i] == nil then
                error("nil passed to class, check the parents")
            end
        end

        local t = nil
        if #args == 1 and type(args[1]) == "table" and not args[1].__class__ then
            t = args[1]
            args = {}
        end

        for i, v in ipairs(args) do
            if type(v) == "string" then
                local t, name = stringtotable(v)
                args[i] = t[name]
            end
        end

        local func = function(t)
            local class = class_generator(name, args, t)
            if set then
                local root_table, name = stringtotable(name)
                root_table[name] = class
            end
            return class
        end

        if t then
            return func(t)
        else
            return func
        end
    end

    function class.private(name)
        return function(...)
            return inheritance_handler(false, name, ...)
        end
    end

    class = setmetatable(class, {
        __call = function(self, name)
            return function(...)
                return inheritance_handler(true, name, ...)
            end
        end,
    })


    function class.issubclass(class, parents)
        if parents.__class__ then parents = {parents} end
        for i, v in ipairs(parents) do
            local found = true
            if v ~= class then
                found = false
                for _, p in ipairs(class.__parents__) do
                    if v == p then
                        found = true
                        break
                    end
                end
            end
            if not found then return false end
        end
        return true
    end

    function class.isinstance(obj, parents)
        return type(obj) == "table" and obj.__class__ and class.issubclass(obj.__class__, parents)
    end

    -- Export a Class Commons interface
    -- to allow interoperability between
    -- class libraries.
    -- See https://github.com/bartbes/Class-Commons
    --
    -- NOTE: Implicitly global, as per specification, unfortunately there's no nice
    -- way to both provide this extra interface, and use locals.
    if common_class ~= false then
        common = {}
        function common.class(name, prototype, superclass)
            prototype.__init__ = prototype.init
            return class_generator(name, {superclass}, prototype)
        end

        function common.instance(class, ...)
            return class(...)
        end
    end

    ---------
    -- End of slither.lua dependency
    ---------

    return class;
end

local class = loadClass();

--- GTA:MTA Lua async thread scheduler.
-- @author Inlife
-- @license MIT
-- @url https://github.com/Inlife/mta-lua-async
-- @dependency slither.lua https://bitbucket.org/bartbes/slither

class "_Async" {
    
    -- Constructor mehtod
    -- Starts timer to manage scheduler
    -- @access public
    -- @usage local asyncmanager = async();
    __init__ = function(self)

        self.threads = {};
        self.resting = 50; -- in ms (resting time)
        self.maxtime = 200; -- in ms (max thread iteration time)
        self.current = 0;  -- starting frame (resting)
        self.state = "suspended"; -- current scheduler executor state
        self.debug = false;
        self.priority = {
            low = {500, 50},     -- better fps
            normal = {200, 200}, -- medium
            high = {50, 500}     -- better perfomance
        };

        self:setPriority("normal");
    end,


    -- Switch scheduler state
    -- @access private
    -- @param boolean [istimer] Identifies whether or not 
        -- switcher was called from main loop
    switch = function(self, istimer)
        self.state = "running";

        if (self.current + 1  <= #self.threads) then
            self.current = self.current + 1;
            self:execute(self.current);
        else
            self.current = 0;

            if (#self.threads <= 0) then
                self.state = "suspended";
                return;
            end

            -- setTimer(function theFunction, int timeInterval, int timesToExecute) 
            -- (GTA:MTA server scripting function)
            -- For other environments use alternatives.
            setTimer(function() 
                self:switch();
            end, self.resting, 1);
        end
    end,


    -- Managing thread (resuming, removing)
    -- In case of "dead" thread, removing, and skipping to the next (recursive)
    -- @access private
    -- @param int id Thread id (in table async.threads)
    execute = function(self, id)
        local thread = self.threads[id];

        if (thread == nil or coroutine.status(thread) == "dead") then
            table.remove(self.threads, id);
            self:switch();
        else
            coroutine.resume(thread);
            self:switch();
        end
    end,


    -- Adding thread
    -- @access private
    -- @param function func Function to operate with
    add = function(self, func)
        local thread = coroutine.create(func);
        table.insert(self.threads, thread);
    end,


    -- Set priority for executor
    -- Use before you call 'iterate' or 'foreach' 
    -- @access public
    -- @param string|int param1 "low"|"normal"|"high" or number to set 'resting' time
    -- @param int|void param2 number to set 'maxtime' of thread
    -- @usage async:setPriority("normal");
    -- @usage async:setPriority(50, 200);
    setPriority = function(self, param1, param2)
        if (type(param1) == "string") then
            if (self.priority[param1] ~= nil) then
                self.resting = self.priority[param1][1];
                self.maxtime = self.priority[param1][2];
            end
        else
            self.resting = param1;
            self.maxtime = param2;
        end
    end,

    -- Set debug mode enabled/disabled
    -- @access public
    -- @param boolean value true - enabled, false - disabled
    -- @usage async:setDebug(true);
    setDebug = function(self, value)
        self.debug = value;
    end,


    -- Iterate on interval (for cycle)
    -- @access public
    -- @param int from Iterate from
    -- @param int to Iterate to
    -- @param function func Iterate using func
        -- Function func params:
        -- @param int [i] Iteration index
    -- @param function [callback] Callback function, called when execution finished
    -- Usage:
        -- @usage async:iterate(1, 10000, function(i)
        --     print(i);
        -- end);
    iterate = function(self, from, to, func, callback)
        self:add(function()
            local a = getTickCount();
            local lastresume = getTickCount();
            for i = from, to do
                func(i); 

                -- int getTickCount() 
                -- (GTA:MTA server scripting function)
                -- For other environments use alternatives.
                if getTickCount() > lastresume + self.maxtime then
                    coroutine.yield()
                    lastresume = getTickCount()
                end
            end
            if (self.debug) then
                print("[DEBUG]Async iterate: " .. (getTickCount() - a) .. "ms");
            end
            if (callback) then
                callback();
            end
        end);

        self:switch();
    end,

    -- Iterate over array (foreach cycle)
    -- @access public
    -- @param table array Input array
    -- @param function func Iterate using func
        -- Function func params:
        -- @param int [v] Iteration value
        -- @param int [k] Iteration key
    -- @param function [callback] Callback function, called when execution finished
    -- Usage:
        -- @usage async:foreach(vehicles, function(vehicle, id)
        --     print(vehicle.title);
        -- end);
    foreach = function(self, array, func, callback)
        self:add(function()
            local a = getTickCount();
            local lastresume = getTickCount();
            for k,v in ipairs(array) do
                func(v,k);

                -- int getTickCount() 
                -- (GTA:MTA server scripting function)
                -- For other environments use alternatives.
                if getTickCount() > lastresume + self.maxtime then
                    coroutine.yield()
                    lastresume = getTickCount()
                end
            end
            if (self.debug) then
                print("[DEBUG]Async foreach: " .. (getTickCount() - a) .. "ms");
            end
            if (callback) then
                callback();
            end
        end);

        self:switch();
    end,
}

-- Async Singleton wrapper
Async = {
    instance = nil,
};

-- After first call, creates an instance and stores it
local function getInstance()
    if Async.instance == nil then
        Async.instance = _Async();
    end

    return Async.instance; 
end

-- proxy methods for public members
function Async:setDebug(...)
    getInstance():setDebug(...);
end

function Async:setPriority(...)
    getInstance():setPriority(...);
end

function Async:iterate(...)
    getInstance():iterate(...);
end

function Async:foreach(...)
    getInstance():foreach(...);
end





















local BLIP_R, BLIP_G, BLIP_B = 255, 255, 255
local BLIP_FACTION = {
	["SAPD"]  = {0, 125, 255},
	["SAMC"]  = {255, 0, 255},
	["SAFD"]   = {175, 10, 0},
	["TSA"]   = {255, 230, 0},
	["SARA"]  = {255, 120, 0},
	["FRIEND"]  = {242, 66, 255},
}

local function destroyBlipsAttachedTo( player )
	local attached = getAttachedElements ( player )
	if ( attached ) then
		for k,element in ipairs(attached) do
			if getElementType ( element ) == "blip" then
				destroyElement ( element )
			end
		end
	end
end

local function isBlipsAttachedTo(elemente)
	local attached = getAttachedElements ( elemente )
	if ( attached ) then
		for k,element in ipairs(attached) do
			if getElementType ( element ) == "blip" then
				return true
			end
		end
	end
	return false
end

local function destroyPlayerBlip( plr )
	destroyBlipsAttachedTo ( plr )
end

function checkIsFriend(plr, target)
    local friends = getElementData(plr, 'player:friends') or {}

    if #friends == 0 then
        return false
    end
    
    for i,v in pairs(friends) do
        if getElementData(target, 'player:sid') == v[1] then
            return true
        end
    end

    return false
end

local function createPlayerBlip( plr, red, green, blue )
	if type(red) ~= "number" then
		red = BLIP_R
	end
	if type(green) ~= "number" then
		green = BLIP_G
	end
	if type(blue) ~= "number" then
		blue = BLIP_B
	end
	destroyBlipsAttachedTo ( plr )
	local blip = createBlipAttachedTo ( plr, 0, 2, red, green, blue, 255, 0, 300 )
    setElementInterior(blip, getElementInterior(plr))
    setElementData(blip, "player:blip", plr)
end

local function createFactionBlip( plr, table, faction )
	destroyBlipsAttachedTo ( plr )
	if type(table) ~= "nil" and faction ~= 'SAPD' then
		local r,g,b = unpack(table)
		local blip = createBlipAttachedTo ( plr, 0, 2, r, g, b, 255, 0, 300 )
        setElementInterior(blip, getElementInterior(plr))
        setElementData(blip, "player:blip", plr)
	end
end

local function createOrganizationBlip(plr)
    local organization = getElementData(localPlayer, "player:organization") or {}

    if organization and organization.name and plr ~= localPlayer then
        for i, v in ipairs(getElementsByType('player')) do
            local org = getElementData(v, "player:organization") or {}
            if org.name == organization.name and v ~= localPlayer then
                createPlayerBlip(v, 125, 255, 125)
            end
        end
    end
end

local function createEveryoneBlip()
  	for id, player in ipairs( getElementsByType ( "player" ) ) do
  		local faction = getElementData( player, "player:duty" )

  		if faction and faction ~= false then
            if not getElementData(player, "player:strefa") then
			    createFactionBlip( player, BLIP_FACTION[faction], faction )
            end
  		else
            createPlayerBlip(player, BLIP_R, BLIP_G, BLIP_B)
  		end
	end

    local organization = getElementData(localPlayer, "player:organization") or {}
    if organization and organization.name and player ~= localPlayer then
        for i, v in ipairs(getElementsByType('player')) do
            local org = getElementData(v, "player:organization") or {}
            if org.name == organization.name and v ~= localPlayer then
                createPlayerBlip(v, 125, 255, 125)
            end
        end
    end
end

local function chcekVehiclesBlips()
	UID = getElementData( localPlayer, "player:sid" )
	ORG = getElementData( localPlayer, "player:organization" ) and getElementData( localPlayer, "player:organization" ).id or nil
	if not UID then return end

	Async:foreach(getElementsByType( "vehicle", getResourceRootElement(getResourceFromName( "since-core")) ), function(vehicle)
--createBlipAttachedTo( element elementToAttachTo, [int icon=0, int size=2, int r=255, int g=0, int b=0, int a=255, int ordering=0, float visibleDistance=99999.0, visibleTo = getRootElement()] )
		if isBlipsAttachedTo(vehicle) == false then
			if getElementData( vehicle, "vehicle:owner" ) == UID then
				local blipcar = createBlipAttachedTo( vehicle, 1, 1, 255, 0, 0, 255, 0, 500 )
			elseif ORG and getElementData( vehicle, "vehicle:organization" ) == ORG then
				local bliporg = createBlipAttachedTo( vehicle, 1, 1, 100, 200, 255, 255, 0, 500 )
			else
				local rent = getElementData( vehicle, "vehicle:rent" )
				if rent and (type(rent) == "table") and #rent > 0 then
					for i,s in pairs(rent) do
						if tonumber(s) == UID then
							local bliprent = createBlipAttachedTo( vehicle, 1, 1, 125, 255, 125, 255, 0, 500 )
						end
					end
				end
			end
		end

	end);
end

addEventHandler ( "onClientResourceStart", resourceRoot, createEveryoneBlip )

addEventHandler ( "onClientPlayerSpawn", root, function()
	createPlayerBlip(source)
end)

addEventHandler ( "onClientPlayerQuit", root, function()
	destroyPlayerBlip(source)
end)

addEventHandler ( "onClientPlayerWasted", root, function()
	destroyPlayerBlip(source)
end)

addEventHandler( "onClientElementDestroy", root, function()
	if isBlipsAttachedTo(source) then
		destroyBlipsAttachedTo(source)
	end
end)

addEventHandler("onClientElementInteriorChange", root, function(old, new)
    if getElementType(source) == 'player' and old ~= new then
        createPlayerBlip(source)
    end
end)

addEventHandler( "onClientElementDataChange", root, function(key, old, new)
	local elementType = getElementType( source )
	if elementType == "player" then
		if key == "player:faction" then
			if new and new ~= false then
				createFactionBlip( source, BLIP_FACTION[new], new )
			else
				createPlayerBlip( source )
			end
        elseif key == 'player:organization' then
            local organization = getElementData(source, "player:organization") or {}

            if organization and organization.name then
                createOrganizationBlip(source)
            else
                createPlayerBlip(source)
            end
        elseif key == "player:inv" then
			if new and new ~= false then
				destroyBlipsAttachedTo( source )
			else
				createPlayerBlip( source )
			end
		end
	elseif elementType == "vehicle" then
		if key == "vehicle:owner" or key == "vehicle:rent" then
			if isBlipsAttachedTo( source ) then
				destroyBlipsAttachedTo( source )
			end
		end
	end
end)
chcekVehiclesBlips()
setTimer( chcekVehiclesBlips, 60000, 0 )
getResourceName(getThisResource(), true, 957461496); if true then return end