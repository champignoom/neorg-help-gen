mkdir norg

for i in *.md; do
	echo $i; pandoc $i -t markdown  --lua-filter=filter.lua --lua-filter=filter2.lua -t json | /home/exp/code/neorg-gen-norg-help/minorg/minorg generate -f -o norgs/${i%.md}.norg
done

for i in norgs/*.norg; do
	echo $i; nvim $i --headless -c 'luafile all.lua'
	sed -i 's@^[*]\+ .* (empty$@& list)@; s@^\( *-\+\) (@\1 \\(@' "$i"
done

sed -i 's@{https://github.com/nvim-neorg/neorg/wiki/\([A-Za-z-]\+\)}@{:\1:}@g; s@{\(Dependencies\)}@{:\1:}@' norgs/Home.norg
