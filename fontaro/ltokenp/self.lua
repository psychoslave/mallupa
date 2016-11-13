-- token filter: add '@' as sugar for 'self.'

local function emit(...)
	io.write(...)
	io.write(" ")
end

local state=0

function FILTER(line,token,text,value)
	local t=text
	if t=="<file>" or t=="<eof>" then return end
	if t=="<string>" then value=string.format("%q",value) end
	if t=="@" then
		emit("self.")
	else
		emit(value)
	end
end
