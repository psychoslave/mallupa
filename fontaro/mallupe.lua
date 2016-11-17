-- leksio filter: for now, just define 'iĝu' as an alias to the affecation operator '='

local function eligu(...)
	io.write(...)
	io.write(" ")
	-- io.write("\n")
end

local state=0

function FILTER(line,leksio,text,valoro)
	local t=text
    local leksio = { -- ĉefaj leksemoj
        ["igxu"] = "=", 
        ["iĝu"] = "=", --[[ unfortunatly non-ASCII characters can't be currently handled by the lua lexer, so this
							kind of unicode entry are useless with it.
						--]]

		["disaŭe"] = "~",
		["disauxe"] = "~",

		["nee"] = "~",
		["kaje"] = "&",

		["kajaux"] = "|",
		["kajaŭ"] = "|",
		["auxe"] = "|",
		["aŭe"] = "|",
		["kaux"] = "|",
		["kaŭ"] = "|",

		["sobŝove"] = ">>",
		["sobsxove"] = ">>",

		["sorŝove"] = "<<",
		["sorsxove"] = "<<",
        
        ["egaligxas"] = "==",
        ["egaliĝas"] = "==",
        ["malalias"] = "==",
		["egalas" ] = "==",
        ["samas"] = "==",

        ["malegaligxas"] = "~=",
        ["malegaliĝas"] = "~=",
        ["neegaligxas"] = "~=",
        ["neegaliĝas"] = "~=",
		["neegalas"] = "~=",
        ["malsamas"] = "~=",
        ["alias"] = "~=",

        ["superiĝas"] = ">",
        ["malantaux"] = ">",
        ["malantaŭ"] = ">",
		["superas"] = ">",
        ["post"] = ">",

        ["malsuperas"] = "<",
        ["infraas"] = "<",
        ["antaux"] = "<",
        ["antaŭ"] = "<",
        ["men"] = "<",

		["almenaŭas"] = ">=",
		["almenauxas"] = ">=",
		["minimumas"] = ">=",
        ["suras"] = ">=",

        ["malalmenauxas"] = "<=",
        ["malalmenaŭas"] = "<=",
        ["maksimumas"] = "<=",
        ["malsuras"] = "<=",
		["subas"] = "<=",

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

		["kies"] = "[", -- do oni skribas "tabelo['enigo'] = 3" kiel "tabelo kies eniga ero iĝu 3"
		["ero"] = "]",
		["a"] = "",
		
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
	local malfleksii = function(fleksieco) 
		return function(valoro) return string.match(valoro, fleksieco) end
		end

    local leksifleksiecaro = { -- leksia (leksikera) fleksi-eca aro
        ["(%a+o)n?$"] = malfleksii, -- match both nominative and accusative: ekzemplo, ekzemplon (but not the ekzempl’ apocope)
        ["(%a+)[iu]$"] =  malfleksii, -- match both infinitive and volitive : ekzempli, ekzemplu
		["^en(%d+)an?$"] = malfleksii, -- en3a -> 3, certe "3a" estus plibona, sed la disleksemilo kraŝas kiel ĝi trovas ĉeno tiele formita. 
        --[[
		["i$"] = "(",
		["u$"] = "(",
		["(%a+)e[n]$"] = "[", -- do oni skribas "tabelo[enigo] = 3" kiel "tabelen enigo iĝu 3"
        -- ideo : distingi -e kaj -en, do ni havas 
        -- tabelo["enigo"] = 3            | tabelo.enigo = 3 | aĵo = tabelo.enigo | tabelo[1] = 3 
        -- tabelo kies "enigo" ero iĝu 3  |  				 |					  |
		-- tabelo kies "enigo"a ero iĝu 3 |					 |					  | tabelo kies 1a ero îgu 3
		-- 								  |										  | 1a-tabelero iĝu 3 -- necesas sintaksan modifion
		--																		  | 1a-tabeleriĝu 3
		-- tabelo kies eniga ero iĝu 3 -- atentu la kazoj kie kaj "eniga", kaj "enig", kaj "enigo" estas tabelenigoj 
        -- tabelo kies enigero iĝu 3 -- necesas memori ĉiuj identigiloj kaj ne ĉiam akopi -ero. Ekzemple se  "vespero"
        --                              estas identigilo, la tradukilo devas provizi "vesper", anstataŭ "vesp"
		-- 								  | tabelen enigero iĝu 3  -- tie, variablo povus indiki ke ni antaŭe malfermis 
        --                                                         	  tabelan konsteksto kun -en		 
		--								  | tabelen enigo iĝu 3
        --                                | tabelenigeriĝu 3       -- ne facile traktebla, ĉar ekzistas tro da disleksemigebloj
        --                                | tabel-enigeriĝu 3      -- far pli facile traktebale, sed  "-" estas uzita kiel substrakto operatoro per Lua
		-- 												      | aĵo iĝu tabele enigo
		-- laŭecformo				traduko
		-- "(%a)en?$"  				"."
		-- "kies" 					"["
		-- "ero" 					"]"
		-- "%a([%a%d])+a$" 			""		-- malplena ĉeno
        ]]--
		["(%a+)en?$"] = function(valoro) return  malfleksii("(%a+)en?$")(valoro) .. "o." end,
		["(%a+)an?$"] = function(valoro) return  "'" .. malfleksii("(%a+)an?$")(valoro) .. "o'" end,
    }


	for fleksieco, lauxige in pairs(leksifleksiecaro) do
		if lauxige == malfleksii then
    		leksifleksiecaro[fleksieco] = lauxige(fleksieco) -- platigas al la sennoma funkcio "function(valoro)" kun la "fleksieco" laŭeco
		end 
	end

	if t =="<file>" or t=="<eof>" then return end
	if t =="<string>" then 
		valoro = string.format("%q",valoro)
	end
    if t == "<name>" then
        if leksio[valoro] then
            valoro = leksio[valoro]
        else
            for fleksieco, malfleksu in pairs(leksifleksiecaro) do
                if string.match(valoro, fleksieco)  then
                    valoro = malfleksu(valoro)
                    break
                end
            end
        end
	end
    eligu(valoro)
    --eligu(text .. ':' .. valoro .. '\n')
--]]
end
