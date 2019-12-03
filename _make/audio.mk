# automatically render lmms projects
AUDIO_LMMS = $(notdir $(patsubst %.mmpz,%.wav,$(wildcard audio/*.mmpz)))

lmms: $(AUDIO_LMMS)
.PHONY: lmms

audio: lmms failsound.ogg applause.ogg
.PHONY: audio

$(AUDIO_LMMS): %.wav: audio/%.mmpz
	lmms --format wav --render "$<" --output "$@"

failsound.ogg: assets/failsound.ogg
	cp "$<" "$@"

applause.ogg: assets/applause.ogg
	cp "$<" "$@"
