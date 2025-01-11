function Figure(fig)
	-- remove all figures
	return {}
end

function RawBlock(elem)
	-- print('@@', elem)
	return {}
end

function RawInline(elem)
	return {}
end

function Div(elem)
	return(elem.content)
	-- return {}
end

function CodeBlock(elem)
	-- print('@@', current_h1, elem.text)
    -- print('@@', elem)
    if not string.find(elem.text, '\n') then
        return pandoc.Para { "default: ", pandoc.Code(elem.text) }
    end
end

