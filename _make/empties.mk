# Empties

empty-sprites = count1.png count2.png count3.png hit300-0.png hit300g-0.png hit300k-0.png inputoverlay-background.png lighting.png ranking-graph.png scorebar-bg.png sliderendcircle.png sliderpoint10.png sliderpoint30.png sliderscorepoint.png spinner-approachcircle.png spinner-clear.png spinner-glow.png spinner-middle.png star2.png

$(empty-sprites): empty.png
	cp assets/empty.png "$@"

# empty-sounds = what?
# $(empty-sounds): empty.wav
# 	cp assets/empty.wav "$@"
