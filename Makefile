# render from dependency to target, with target as exact output name
blender = blender -b "$<" -o "//$@\#" $(1) && mv "$@"? "$@"

cursormiddle@2x.png: cursor.blend
	$(call blender, -f 1)

cursor@2x.png: cursor.blend
	$(call blender, -f 2)

newskin.zip: *.png
	7z a "$@" $^

.PHONY: export
export: newskin.zip
	mv $< $(basename $<).osk
