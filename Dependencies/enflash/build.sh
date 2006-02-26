#!/bin/sh
#
#EnFlash 0.4 build script for GNU/Linux and Mac OS X. Use this as a reference to create your own simplified scripts.
#Requires MTASC 1.06+ and optionally swfmill 0.2.7.6+ that are included in your PATH.
#Does not require Macromedia Flash and FLA files.
#Example usage: ./build.sh xmldemo

amfdemo(){
  mtasc -cp src/classes -cp deploy/demos -swf deploy/demos/amfdemo.swf -main AMFDemo.as -frame 2 -header 960:620:21:000000
}
apidemo(){
  mtasc -cp src/classes -cp deploy/demos -swf deploy/demos/apidemo.swf -main APIDemo.as -frame 2 -header 960:620:21:000000
}
windemo(){
  swfmill simple src/flas/demos/windemo.swfml deploy/demos/windemo.swf
  mtasc -cp src/classes -cp deploy/demos -swf deploy/demos/windemo.swf -main WinDemo.as -frame 2
}
xmldemo(){
  swfmill simple src/flas/demos/xmldemo.swfml deploy/demos/xmldemo.swf
  mtasc -cp src/classes -cp deploy/demos -swf deploy/demos/xmldemo.swf -main XMLDemo.as -frame 2
}

case "$1" in
amfdemo)
  amfdemo;;
apidemo)
  apidemo;;
windemo)
  windemo;;
xmldemo)
  xmldemo;;
*)
  amfdemo
  apidemo
  windemo
  xmldemo;;
esac