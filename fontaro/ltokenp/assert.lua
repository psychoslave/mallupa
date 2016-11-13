-- token filter: remove calls to assert

local ASSERT="assert"

local function emit(s)
	io.write(s," ")
end

local state=0
local level=0
local lastline=1

function FILTER(line,token,text,value)
	if text=="<file>" or text=="<eof>" then return end
	while lastline~=line do lastline=lastline+1 emit("\n") end
	if text=="<string>" then value=string.format("%q",value) end
	if state==0 then
		if text=="<name>" and value==ASSERT then
			state=1
		else
			emit(value)
		end
	elseif state==1 then
		if text=="(" then
			level=1
			state=2
		elseif text=="<name>" and value==ASSERT then
			emit(ASSERT)
		else
			emit(ASSERT)
			emit(value)
			state=0
		end
	elseif state==2 then
		if text=="(" then
			level=level+1
		elseif text==")" then
			level=level-1
			if level==0 then
				state=0
			end
		end
	end
end
