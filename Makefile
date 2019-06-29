cursormiddle@2x.png: cursor.blend
	blender -b $< -o $@ -f 1

cursor@2x.png: cursor.blend
	blender -b $< -o $@ -f 2
