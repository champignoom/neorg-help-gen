#!/bin/bash

DIR="$(dirname "$0")"

mkdir norg

for i in *.md; do
	echo $i; pandoc $i -t markdown  --lua-filter="$DIR/filter.lua" --lua-filter="$DIR/filter2.lua" -t json | /home/exp/code/neorg-gen-norg-help/minorg/minorg generate -f -o norgs/${i%.md}.norg
done

for i in norgs/*.norg; do
	echo $i; nvim $i --headless -c "luafile $DIR/all.lua"
	sed -i 's@^[*]\+ .* (empty$@& list)@; s@^\( *-\+\) (@\1 \\(@; s@{https://github.com/nvim-neorg/neorg/wiki/\([A-Za-z-]\+\)}@{:\1:}@g; s@{\(Dependencies\)}@{:\1:}@' "$i"
done

rm norgs/_Sidebar.norg

