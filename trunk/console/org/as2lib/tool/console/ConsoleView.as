import org.as2lib.env.event.EventListener;
import org.as2lib.tool.console.ConsoleConnection;

/**
 * Interface to be used for all Views of the console.
 */
interface org.as2lib.tool.console.ConsoleView extends EventListener {
	
	/**
	 * Event if the selected Connection changed.
	 */
	public function changeConnection(connection:ConsoleConnection):Void;
	
	/**
	 * Hides the view.
	 */
	public function hide(Void):Void;
	
	/**
	 * Displayes the view.
	 */
	public function show(Void):Void;
	
	/**
	 * Displayes the name of the view.
	 */
	public function getName(Void):String;
}