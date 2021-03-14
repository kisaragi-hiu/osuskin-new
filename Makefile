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

optimize: $(target-images)
	pngquant --force --skip-if-larger --ext png "$@"

resize: $(target-images)
	parallel vips resize '{}' $(basename '{}' @2x.png).png 0.5 ":::" *@2x.png
