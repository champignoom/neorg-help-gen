traverse = 'topdown'

function Pandoc(elem)
	-- print('@@', elem)
end

local current_h1 = nil

function Header(elem)
	if elem.level==1 then
		current_h1 = elem.content[1].text
	end
end

local function replace_elem(elem_full, pat_full, repl)
    local m = {}
    local function collect(elem, pat)
        if elem == nil then
            -- print('## nil elem', pat)
            return false
        end
        if type(pat) == 'string' then
            if pat:sub(1,1) == '=' then
                m[pat:sub(2)] = elem
                -- print('## saving', pat, elem)
                return true
            end
            -- print('## raw tag', elem, elem.tag, pat)
            return elem.tag == pat
        end
        if #pat == 0 then
            -- print('## tag detail', pat)
            local k,v = next(pat)
            assert(k)
            -- print('## detail between', elem.tag, k)
            if not elem.tag == k then
                return false
            end

            if not collect(elem.content or elem.text, v, m) then
                return false
            end

            local k,v = next(pat, k)
            assert(k==nil, k)
            return true
        end

        for i,p in ipairs(pat) do
            -- print('## descend', elem[i], p)
            if not collect(elem[i], p, m) then
                return false
            end
        end
        return true
    end

    if not collect(elem_full, pat_full, m) then
        return false
    end

    local new_elems = repl(m)

    for i = 1, #pat_full do
        elem_full:remove(1)
    end

    if type(new_elems) == 'string' then
        new_elems = { new_elems }
    end

    for i = #new_elems, 1, -1 do
        elem_full:insert(1, new_elems[i])
    end

    return true
end

local function flatten(lists)
    local res = {}
    for _,l in ipairs(lists) do
        for _,v in ipairs(l) do
            table.insert(res, v)
        end
    end
    return res
end

local bullet_list_level = 0
function BulletList(elem)
	if current_h1 ~= "Configuration" then
		return
	end
    -- print('>>>>>>>>>')

    -- elem.content[1][1] = {}
    -- elem.content[1]:insert( 1, 'asdf')
      -- print('##bullet', type(elem.content), elem.content[1])
     -- RawBlock (Format "html") "<details open>",RawBlock (Format "html") "<summary>",RawBlock (Format "html") "<h6>",Plain [RawInline (Format "html") "<code>",Str "folds"],RawBlock (Format "html") "</h6>",Plain [RawInline (Format "html") "</code>",Space,Str "(boolean)"],RawBlock (Format "html") "</summary>"
     -- RawBlock, RawBlock, RawBlock, Plain [RawInline, Str "folds"], RawBlock, Plain [RawInline, Space, Str "(boolean)"], RawBlock
     local t = { 'RawBlock', 'RawBlock', 'RawBlock', { Plain = { 'RawInline', { Str = '=title' } } }, 'RawBlock', { Plain = { 'RawInline', 'Space', { Str = '=typ' } } }, 'RawBlock' }
     -- print('##', bullet_list_level, elem.content[1][1], '$$', elem.content[2])
     local function f(m)
         return { pandoc.Header(2 + bullet_list_level, pandoc.Str(("%s %s"):format(m.title, m.typ))) }
     end
 
     for i,e in ipairs(elem.content) do
         if not replace_elem(e, t, f) then
             return
         else
             -- print(e)
         end
     end

    bullet_list_level = bullet_list_level + 1
    -- print('## >>>>', bullet_list_level, elem.content)

    elem = elem:walk {
        traverse = 'topdown',
        BulletList = BulletList,
    }

    bullet_list_level = bullet_list_level - 1
    -- print('## <<<<', bullet_list_level, elem.content)
    -- print(type( elem.content))
    -- print('#', elem, '######', elem.content)
    return  flatten(elem.content)
end
