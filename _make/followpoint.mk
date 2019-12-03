# Followpoint
followpoint-a = followpoint-0@2x.png followpoint-1@2x.png followpoint-2@2x.png followpoint-3@2x.png followpoint-4@2x.png followpoint-5@2x.png followpoint-6@2x.png followpoint-7@2x.png

followpoint-b = followpoint-8@2x.png followpoint-9@2x.png followpoint-10@2x.png followpoint-11@2x.png followpoint-12@2x.png followpoint-13@2x.png followpoint-14@2x.png followpoint-15@2x.png followpoint-16@2x.png

$(followpoint-a): followpoint-0@2x.svg
	inkscape -z "$<" -e "$@"

$(followpoint-b): followpoint-8@2x.svg
	inkscape -z "$<" -e "$@"
