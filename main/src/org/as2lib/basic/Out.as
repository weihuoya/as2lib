import org.as2lib.basic.Exception

/**
 * Output Class, to do an Output to anywhere.
 * Class where basic Output Functions should be Defined
 * 
 * @autor	Martin Heidegger
 * @date	13.11.2003
 */

class org.as2lib.basic.Out {
	
	/**
	 * Converts an Exception to a Warning an writes it to the Standard Output
	 * 
	 * @see Exception
	 * 
	 * @param e		Exception that should be displayed as Warning
	 */
	static function warning (e:Exception) {
		trace(e.toWarning());
	}
}