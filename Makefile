# render from dependency to target, with target as exact output name
blender_target = blender -b "$<" -o "//$@\#" $(1) && mv "$@"? "$@"

$(shell mkdir -p out)

# Audio {{{
# automatically render lmms projects
AUDIO_LMMS = $(addprefix out/,$(notdir $(patsubst %.mmpz,%.wav,$(wildcard audio/*.mmpz))))

lmms: $(AUDIO_LMMS)
.PHONY: lmms

audio: lmms out/failsound.ogg out/applause.ogg
.PHONY: audio

$(AUDIO_LMMS): out/%.wav: audio/%.mmpz
	lmms --format wav --render "$<" --output "$@"

out/failsound.ogg: assets/failsound.ogg
	cp "$<" "$@"

out/applause.ogg: assets/applause.ogg
	cp "$<" "$@"

# }}}

# Empties {{{

empty-sprites = $(addprefix out/,count1.png count2.png count3.png hit300-0.png hit300g-0.png hit300k-0.png inputoverlay-background.png lighting.png ranking-graph.png scorebar-bg.png sliderendcircle.png sliderpoint10.png sliderpoint30.png sliderscorepoint.png spinner-approachcircle.png spinner-clear.png spinner-glow.png spinner-middle.png star2.png)

empty: $(empty-sprites)
.PHONY: empty

$(empty-sprites): empty.png
	cp assets/empty.png "$@"

# empty-sounds = what?
# $(empty-sounds): empty.wav
# 	cp assets/empty.wav "$@"
# }}}

# Other {{{

fail-background@2x.png: backgrounds.blend
	$(call blender_target, -f 1)

pause-overlay@2x.png: backgrounds.blend
	$(call blender_target, -f 2)

arrow-pause@2x.png: arrows.blend
	$(call blender_target, -f 1)

arrow-warning@2x.png: arrows.blend
	$(call blender_target, -f 2)

cursormiddle@2x.png: cursor.blend
	$(call blender_target, -f 1)

cursor@2x.png: cursor.blend
	$(call blender_target, -f 2)

# }}}

newskin.zip: *.png
	7z a "$@" $^

.PHONY: export
export: newskin.zip
	mv $< $(basename $<).osk

PICTURES_SVG = approachcircle@2x.svg hitcircle@2x.svg hitcircleoverlay@2x.svg inputoverlay-key.svg menu-button-background@2x.svg selection-tab@2x.svg sliderb@2x.svg sliderfollowcircle.svg sliderscorepoint@2x.svg sliderstartcircle@2x.svg sliderstartcircleoverlay@2x.svg spinner-middle2@2x.svg spinner-rpm@2x.svg

$(PICTURES_SVG): %.png: %.svg
	inkscape -z "$<" -e "$(basename $<)".png

# $(PICTURES_BLENDER_NORMAL): %.png: %.blend
# 	blender -b "$<" -a
# $(PICTURES_BLENDER_MARKER): %.png: %.blend
# 	blender -b "$<" --python render_marker.py
