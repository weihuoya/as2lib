/**
 * @version 1.0
 */
interface org.as2lib.basic.event.EventInfo {
	/**
	 * @return The specified name.
	 */
	public function getName(Void):String;
	
	/**
	 * Marks the event consumed.
	 */
	public function consume(Void):Void;
	
	/**
	 * Checks if the event is marked as consumed.
	 * @return true if the event is consumed else false
	 */
	public function isConsumed(Void):Boolean;
}