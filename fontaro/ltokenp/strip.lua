-- token filter: strip comments and whitespace

local CLASH={}

local function setclash(a,b)
	if CLASH[a]==nil then CLASH[a]={} end
	CLASH[a][b]=true
end

local function clash(a,b)
	return CLASH[a]~=nil and CLASH[a][b]~=nil
end

setclash('-',	'-')
setclash('.',	'.')
setclash('.',	'..')
setclash('.',	'...')
setclash('.',	'<number>')
setclash('..',	'.')
setclash('..',	'..')
setclash('..',	'...')
setclash('..',	'<number>')
setclash('/',	'/')
setclash('/',	'//')
setclash(':',	':')
setclash(':',	'::')
setclash('<',	'<')
setclash('<',	'<<')
setclash('<',	'<=')
setclash('<',	'=')
setclash('<',	'==')
setclash('=',	'=')
setclash('=',	'==')
setclash('>',	'=')
setclash('>',	'==')
setclash('>',	'>')
setclash('>',	'>=')
setclash('>',	'>>')
setclash('[',	'=')
setclash('[',	'==')
setclash('[',	'[')
setclash('~',	'=')
setclash('~',	'==')
setclash('<name>',	'<name>')
setclash('<name>',	'<number>')
setclash('<number>',	'.')
setclash('<number>',	'..')
setclash('<number>',	'...')
setclash('<number>',	'<name>')
setclash('<number>',	'<number>')

local emit=io.write
local none=""
local lasttoken=none
local lastline=1

local function emitlines(preserve,line)
	if preserve>0 then
		if line~=lastline then
			if preserve>1 then
				while lastline~=line do
					lastline=lastline+1
					emit("\n")
				end
			elseif lasttoken~=none then
				emit("\n")
			end
			lastline=line
			lasttoken=none
		end
	end
end

local function emitspace(a,b)
	if a:match("^%l") then a="<name>" end
	if b:match("^%l") then b="<name>" end
	if clash(a,b) then emit(" ") end
end

function FILTER(line,token,text,value)
	local t=text
	if t=="<file>" then lasttoken=none lastline=1 return end
	emitlines(0,line)
	if t=="<eof>" then return end
	if t=="<integer>" then t="<number>" end
	emitspace(lasttoken,t)
	if t=="<string>" then value=string.format("%q",value):gsub("\n","n") end
	emit(value)
	lasttoken=t
end
