/**
 * The Consumeable interface can be implemented by EventInfos.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
interface org.as2lib.env.event.Consumeable {
	/**
	 * Marks the Consumeable as consumed.
	 */
	public function consume(Void):Void;
	
	/**
	 * Returns whether the Consumeable has already been consumed.
	 *
	 * @return true if the Consumeable is marked as consumed else false
	 */
	public function isConsumed(Void):Boolean;
}