:EnFlash 0.4 build script for Windows OS. Use this as a reference to create your own simplified scripts.
:Requires installed versions of MTASC 1.06+ and swfmill 0.2.7.6+ that are added to your PATH.
:Does not require Macromedia Flash and FLA files.
:Example usage: build xmldemo

@if "%1"=="amfdemo" goto amfdemo
@if "%1"=="apidemo" goto apidemo
@if "%1"=="windemo" goto windemo
@if "%1"=="xmldemo" goto xmldemo

:amfdemo
mtasc -cp src/classes -cp deploy/demos -swf deploy/demos/amfdemo.swf -main AMFDemo.as -frame 2 -header 960:620:21:000000
@if not "%1"=="" goto end

:apidemo
mtasc -cp src/classes -cp deploy/demos -swf deploy/demos/apidemo.swf -main APIDemo.as -frame 2 -header 960:620:21:000000
@if not "%1"=="" goto end

:windemo
swfmill simple src/flas/demos/windemo.swfml deploy/demos/windemo.swf
mtasc -cp src/classes -cp deploy/demos -swf deploy/demos/windemo.swf -main WinDemo.as -frame 2
@if not "%1"=="" goto end

:xmldemo
swfmill simple src/flas/demos/xmldemo.swfml deploy/demos/xmldemo.swf
mtasc -cp src/classes -cp deploy/demos -swf deploy/demos/xmldemo.swf -main XMLDemo.as -frame 2

:end