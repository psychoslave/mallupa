-- token filter: for now, just define 'iĝu' as an alias to the affecation operator '='

local function emit(...)
	io.write(...)
	io.write(" ")
	io.write("\n")
end

local state=0

function FILTER(line,token,text,value)
	local t=text
    local token = {
        ["iĝu"] = "=", --[[ unfortunatly non-ASCII characters can't be currently handled by the lua lexer, so this
							kind of entry are useless with it.
						--]]
        ["igxu"] = "=", 

		["disaŭe"] = "~",
		["disauxe"] = "~",

		["nee"] = "~",
		["kaje"] = "&",

		["aŭe"] = "|",
		["auxe"] = "|",
		["kajaŭ"] = "|",
		["kajaux"] = "|",
		["kaŭ"] = "|",
		["kaux"] = "|",

		["sobŝove"] = ">>",
		["sobsxove"] = ">>",

		["sorŝove"] = "<<",
		["sorsxove"] = "<<",
        
		["egalas" ] = "==",
        ["egaliĝas"] = "==",
        ["egaligxas"] = "==",
        ["samas"] = "==",

		["neegalas"] = "~=",
        ["neegaliĝas"] = "~=",
        ["neegaligxas"] = "~=",
        ["malsamas"] = "~=",

		["superas"] = ">",
        ["superiĝas"] = ">",

		["estas malpli granda ol "] = "<",
        ["infraas**"] = "<",
        ["malsuperas"] = "<",
        ["men"] = "<",

		["almenaŭas "] = ">=",
        ["suras"] = ">=",

		["subas"] = "<=",
        ["malalmenaŭas"] = "<=",
        ["malsuras"] = "<=",

		["plus"] = "+",

		["kontraŭ"] = "-", -- Unuloka kontraŭo 
        ["mal"] = "-", -- FARENDA: pritrakti kiel reala prefikso 

        ["minus"] = "-", -- Subtraho

		["multiplike"] = "*",
        ["oble"] = "*",

		["disige"] = "/",
        ["divide"] = "/",
        ["ozle"] = "/",
        
		["onige"] = "//", -- FARENDA: pritrakti la "-on-" afikso
        ["parte"] = "//",

		["kongrue"] = "%",
        ["module"] = "%",

		["alt"] = "^",
        ["potencige"] = "^",
		["ne"] = "not",

		["aŭ"] = "or",
		["aux"] = "or",

		["kaj"] = "and",

		["vera"] = "true",
		["malfalsa"] = "true",

		["falsa"] = "false",
        ["malvera"] = "false",

		-- ["tuj"] = ",", -- lastvalora operatoro, ne ekzistas en Lua
		["plie"] = ",", -- disigilo de esprimo

		["nu"] = ";",
		["propra"] = ".",
		["sin"] = ":",
		["etikede"] = "::",
        -- NOTU: en pluraj programlingvoj, "::" estas operatoro por trafa rezolucio
		-- "kie" aŭ "teke" povus esti uzita por tio, sed tio ne ekzistas en Lua

		["sia"] = "self", -- teknike, tio ne vere estas rezervita vorto en la Lua realigo

		["kunlige"] = "..",
        ["kunmete"] = "..",
        ["kroĉe"] = "..",
        ["krocxe"] = "..",
        ["lige"] = "..",

		["ktp"] = "...",
		["cit"] = "\"",
		["ĉit"] = "\"",
		["cxit"] = "\"",
        ["malcit"] = "\"",

		["je"] = "(",

		["grupe"] = ")",
        ["op"] = ")",
        ["ope"] = ")",
		["**kiel**"] = ")",
        ["proceze"] = ")",
        ["rule"] = ")",

		["difinu"] = "function",
        ["verbigu"] = "function",
        ["verba"] = "function",
        ["funkcia"] = "function",

		["kies"] = "[", -- do oni skribas "tabelo['enigo'] = 3" kiel "tabelo kies enigro ere iĝu 3"
		["ere"] = "]",

		["ties"] = ".",

		["de"] = "{", -- do oni scribas "elementaro = { 1, 2, 3 }" kiel "elementaro iĝu de 1, 2, 3 are"
		["are"] = "}",

		["kvante"] = "#",
        ["longo de"] = "#",
        ["longize"] = "#",
        ["mezure"] = "#",
        ["pese"] = "#",

		["ĉesige (cxesige)"] = "break",
        ["eksterŝalte"] = "break",
        ["ekstersxalte"] = "break",
        ["rompe"] = "break",
        ["rompen"] = "break",

		["fare"] = "do",
		["faru"] = "do",

		["alie"] = "else",
		["alise"] = "elseif",

		["hop"] = "end",
        ["fine"] = "end",
        ["malinge"] = "end",

        ["por"] = "for",

		["ŝalte"] = "goto",
		["sxalte"] = "goto",
		["ŝaltu"] = "goto",
		["sxaltu"] = "goto",

		["se"] = "if",
		["el"] = "in",

		["loka"] = "local",
		["nomu"] = "local",

		["nenio"] = "nil",
		["cikle"] = "repeat",

		["reŝalte"] = "return",
		["resxalte"] = "return",
		["resxaltu"] = "return",
		["returne"] = "return",
		["returnu"] = "return",

		["tiam"] = "then",
		["ĝis"] = "until",
		["gxis"] = "until",
		["dum"] = "while",
    }
    local token_pattern = {
        "(%a+)on?$", -- match both nominative and accusative: ekzemplo, ekzemplon (but not the ekzempl’ apocope)
        "(%a+)[iu]$", -- match both infinitive and volitive : ekzempli, ekzemplu (but not the ekzempl’ apocope)
        --[[
		["i"] = "(",
		["u"] = "(",
		["(%a+)e"] = "[", -- do oni skribas "tabelo[enigo] = 3" kiel "tabele enigo iĝu 3"
        -- ideo : distingi -e kaj -en, do ni havas 
        -- tabelo["enigo"] = 3          | tabelo.enigo = 3 | aĵo = tabelo.enigo
        -- tabelo kies enigo ere iĝu 3  | tabelen enigo iĝu 3
        ]]--
    }
	if t=="<file>" or t=="<eof>" then return end
	if t=="<string>" then value=string.format("%q",value) end
    if t == "<name>" then
        if token[value] then
            value = token[value]
        else
            for drop, pattern in ipairs(token_pattern) do
                if string.match(value, pattern)  then
                    value = string.match(value, pattern)
                    break
                end
            end
        end
	end
    emit(value)
    --emit(text .. ':' .. value)
    --]]
end
