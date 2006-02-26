class com.asual.enflash.utils.Time {
	
	/**
	 * Executes a method or function after a given timeout.<br />
	 * Example: <code>Time.setTimeout(Selection, "setSelection", 1000, beginIndex, endIndex);</code>
	 * 
	 * @param object The object that contains the method that will be invoked
	 * @param method The method that will be executed
	 * @param time The timeout time in milliseconds
	 * @param arg (optional) Multiple arguments that will be passed to the method
	 * @return Timeout number that can be supplied to the clearTimeout() method
	 */ 
	public static function setTimeout(object:Object, method:String, time:Number, arg:Object):Number {   
		var timeout:Number = Number(setInterval.apply(null, arguments));
		setInterval(clearTimeout, arguments[2], timeout);   
		return timeout;
	}
	
	/**
	 * Clears a timeout execution before it happens.
	 * 
	 * @param timeout The timeout number returned by the setTimeout() method
	 */
	public static function clearTimeout(timeout:Number):Void {
		clearInterval(timeout);
		clearInterval(++timeout);
	}
}