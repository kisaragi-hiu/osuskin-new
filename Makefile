# render from dependency to target, with target as exact output name
blender_target = blender -b "$<" -x 0 -F PNG -o "//$@\#" $(1) && mv "$@"? "$@"

$(shell mkdir -p out)

# Font files {{{

FONT_DIR_NOTOSANS = /usr/share/fonts/noto-cjk/
FONT_DIR_OVERPASS = /usr/share/fonts/OTF/
NOTOSANSCJK = $(addprefix assets/,NotoSansCJK-Black.ttc NotoSansCJK-Bold.ttc NotoSansCJK-DemiLight.ttc NotoSansCJK-Light.ttc NotoSansCJK-Medium.ttc NotoSansCJK-Regular.ttc NotoSansCJK-Thin.ttc)
OVERPASS = $(addprefix assets/,overpass-bold-italic.otf overpass-bold.otf overpass-extrabold-italic.otf overpass-extrabold.otf overpass-extralight-italic.otf overpass-extralight.otf overpass-heavy-italic.otf overpass-heavy.otf overpass-italic.otf overpass-light-italic.otf overpass-light.otf overpass-regular.otf overpass-semibold-italic.otf overpass-semibold.otf overpass-thin-italic.otf overpass-thin.otf)

$(NOTOSANSCJK): assets/%.ttc: $(FONT_DIR_NOTOSANS)/%.ttc
	cp "$<" "$@"

$(OVERPASS): assets/%.otf: $(FONT_DIR_OVERPASS)/%.otf
	cp "$<" "$@"

.PHONY: fonts
fonts: $(NOTOSANSCJK) $(OVERPASS)

# }}}

# Audio {{{
# automatically render lmms projects
AUDIO_LMMS = $(addprefix out/,$(notdir $(patsubst %.mmpz,%.wav,$(wildcard audio/*.mmpz))))

audio: $(AUDIO_LMMS) out/failsound.ogg out/applause.ogg
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

# SVG Based {{{

PICTURES_SVG = $(addprefix out/,$(patsubst %.svg,%.png,approachcircle@2x.svg hitcircle@2x.svg hitcircleoverlay@2x.svg inputoverlay-key.svg menu-button-background@2x.svg selection-tab@2x.svg sliderb@2x.svg sliderfollowcircle.svg sliderscorepoint@2x.svg sliderstartcircle@2x.svg sliderstartcircleoverlay@2x.svg spinner-middle2@2x.svg spinner-rpm@2x.svg))

$(PICTURES_SVG): out/%.png: %.svg
	inkscape -z "$<" -e "$@"

# }}}

# Followpoint {{{
followpoint-a = $(addprefix out/,followpoint-0@2x.png followpoint-1@2x.png followpoint-2@2x.png followpoint-3@2x.png followpoint-4@2x.png followpoint-5@2x.png followpoint-6@2x.png followpoint-7@2x.png)

followpoint-b = $(addprefix out/,followpoint-8@2x.png followpoint-9@2x.png followpoint-10@2x.png followpoint-11@2x.png followpoint-12@2x.png followpoint-13@2x.png followpoint-14@2x.png followpoint-15@2x.png followpoint-16@2x.png)

$(followpoint-a): followpoint-0@2x.svg
	inkscape -z "$<" -e "$@"

$(followpoint-b): followpoint-8@2x.svg
	inkscape -z "$<" -e "$@"
# }}}

# Other {{{

png: out/fail-background@2x.png out/pause-overlay@2x.png out/arrow-pause@2x.png out/arrow-warning@2x.png out/cursormiddle@2x.png out/cursor@2x.png $(PICTURES_SVG) $(followpoint-a) $(followpoint-b)
.PHONY: png

out/fail-background@2x.png: backgrounds.blend
	$(call blender_target, -f 1)

out/pause-overlay@2x.png: backgrounds.blend
	$(call blender_target, -f 2)

out/arrow-pause@2x.png: arrows.blend
	$(call blender_target, -f 1)

out/arrow-warning@2x.png: arrows.blend
	$(call blender_target, -f 2)

out/cursormiddle@2x.png: cursor.blend
	$(call blender_target, -f 1)

out/cursor@2x.png: cursor.blend
	$(call blender_target, -f 2)

# }}}

# SD auto conversion

SD = $(patsubst %.@2x.png,%,$(wildcard *@2x.png))

# or convert -resize 50% "$<" "$@"
$(SD): %.png: %@2x.png
	vips resize "$<" "$@" 0.5

newskin.zip: *.png
	7z a "$@" $^

.PHONY: export
export: newskin.zip
	mv $< $(basename $<).osk

# $(PICTURES_BLENDER_NORMAL): %.png: %.blend
# 	blender -b "$<" -a
# $(PICTURES_BLENDER_MARKER): %.png: %.blend
# 	blender -b "$<" --python render_marker.py
