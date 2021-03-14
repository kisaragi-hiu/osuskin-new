source-lmms = $(shell find . -name .mmpz)

target-lmms = $(patsubst %.mmpz,%.wav,$(source-lmms))
target-krita = $(patsubst %.kra,%.png,$(source-lmms))

$(target-lmms): %.wav: %.mmpz
	lmms --format wav render "$<" --output "$@"

$(target-blender): %.png: %.blend
	blender -b "$<" -a

$(target-krita): %.png: %.kra
	krita "$<" --export --export-filename "$@"

$(target-inkscape): %.png: %.svg
	inksacpe -z "$<" -e "$@"

$(target-empty-sample): %.wav: assets/empty.wav
	cp "$<" "$@"

optimize: $(target-images)
	pngquant --force --skip-if-larger --ext png "$@"

resize: $(target-images)
	parallel vips resize '{}' $(basename '{}' @2x.png).png 0.5 ":::" *@2x.png

samples = osu-resources/osu.Game.Resources/Samples

import-samples:
	cp $(samples)/Keyboard/* .
	cp $(samples)/Gameplay/* .
	cp $(samples)/Intro/*.mp3 .
	cp $(samples)/Menu/button-back-select.wav menuback.wav
	cp $(samples)/Menu/button-direct-select.wav menu-direct-click.wav
	cp $(samples)/Menu/button-edit-select.wav menu-edit-click.wav
	cp $(samples)/Menu/button-generic-select.wav menuhit.wav
	cp $(samples)/Menu/button-play-select.wav menu-play-click.wav
	cp $(samples)/Menu/button-solo-select.wav menu-freeplay-click.wav
	cp $(samples)/Menu/osu-logo-heartbeat.wav heartbeat.wav
	cp $(samples)/SongSelect/select-difficulty.mp3 .
	cp $(samples)/SongSelect/select-expand.mp3 .
	cp $(samples)/UI/check-on.wav
	cp $(samples)/UI/check-off.wav
	cp $(samples)/UI/slidebar-notch.wav slidebar.wav
