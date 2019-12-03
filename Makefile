# render from dependency to target, with target as exact output name
blender = blender -b "$<" -o "//$@\#" $(1) && mv "$@"? "$@"

include _make/followpoint.mk
include _make/empties.mk

# Other

cursormiddle@2x.png: cursor.blend
	$(call blender, -f 1)

cursor@2x.png: cursor.blend
	$(call blender, -f 2)

newskin.zip: *.png
	7z a "$@" $^

.PHONY: export
export: newskin.zip
	mv $< $(basename $<).osk


# automatically render lmms projects
AUDIO_LMMS = $(addsuffix .wav,$(basename $(wildcard audio/*.mmpz)))
$(AUDIO_LMMS): %.wav: %.mmpz
	lmms --format wav --render audio/"$<" --output "$@"

failsound.ogg: assets/failsound.ogg
	cp "$<" "$@"

applause.ogg: assets/applause.ogg
	cp "$<" "$@"

PICTURES_SVG = approachcircle@2x.svg hitcircle@2x.svg hitcircleoverlay@2x.svg inputoverlay-key.svg menu-button-background@2x.svg selection-tab@2x.svg sliderb@2x.svg sliderfollowcircle.svg sliderscorepoint@2x.svg sliderstartcircle@2x.svg sliderstartcircleoverlay@2x.svg spinner-middle2@2x.svg spinner-rpm@2x.svg

$(PICTURES_SVG): %.png: %.svg
	inkscape -z "$<" -e "$(basename $<)".png

$(PICTURES_BLENDER_NORMAL): %.png: %.blend
	blender -b "$<" -a

$(PICTURES_BLENDER_MARKER): %.png: %.blend
	blender -b "$<" --python render_marker.py
