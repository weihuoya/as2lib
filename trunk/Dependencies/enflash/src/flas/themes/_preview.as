if (this == _root)  {
	this.onEnterFrame = function(){
		for (var mc in this){
			this[mc].gotoAndStop(_currentframe);
		}
		stop();
	}
	fscommand("allowscale", false);
}
stop();