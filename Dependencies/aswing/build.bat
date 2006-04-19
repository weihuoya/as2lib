@echo off
mkdir bld
mtasc -header 800:600:20 -cp ./src -cp ./tst -swf ./bld/%1.swf -main test/%1 -pack org/aswing/debug -trace org.aswing.debug.Log.log
