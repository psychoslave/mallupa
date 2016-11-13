-- token filter: allow reserved words as field names

local function emit(...)
	io.write(...)
	io.write(" ")
end

local state=0

function FILTER(line,token,text,value)
	local t=text
	if t=="<file>" or t=="<eof>" then return end
	if t=="<string>" then value=string.format("%q",value) end
	if state==0 then
		if t=="." then
			state=1
		else
			emit(value)
		end
	elseif state==1 then
		if t:match("^%l") then
			emit("['",t,"']")
			state=0
		else
			emit(".")
			if t~="." then
				state=0
			end
		end
	end
end
