/* See LICENSE for copyright and terms of use */

//no need to subclass org.actionstep.constants.ASConstantValue,
//since super class has already done so
import org.actionstep.constants.NSRunResponse;

/**
 * The following values are derivatives of <code>org.actionstep.constants.NSRunResponse</code>,
 * since functions handling these values are not aware of their content and merely
 * pass it along.
 *
 * These values are used as return codes from <code>NSAlert</code> functions.
 *
 * Please note that return values for buttons are position dependant. If you have
 * more than three buttons on your alert, the button-position return value is
 * NSThirdButtonReturn + n, where n is an integer.
 */

 /* (Localization is as yet unsupported, so JavaDoc flag not used; placed here for the future)
 * For languages that read right to left, the first button’s position is closest to the
 * left edge of the dialog or sheet.
 */

class org.actionstep.constants.NSAlertReturn extends NSRunResponse {
	//******************************************************
	//*                    Return values for alert panels
	//******************************************************

	/**
	* The value returned when the first (default) button from the right
	 * edge of the NSAlertPanel is clicked.
	 */
	public static var NSDefault:NSAlertReturn		 = new NSAlertReturn(1);

	/**
	 * The value returned when the second button from the right edge of the
	 * NSAlertPanel is clicked.
	 */
	public static var NSAlternate:NSAlertReturn	 = new NSAlertReturn(0);

	/**
	 * The value returned when the third button from the right edge of the NSAlertPanel is clicked.
	 */
	public static var NSOther:NSAlertReturn	 = new NSAlertReturn(-1);

	/**
	 * The value returned if running the NSAlertPanel resulted in an error.
	 */
	public static var NSError:NSAlertReturn	 = new NSAlertReturn(-2);

	//******************************************************
	//*      Return values for buttons
	//******************************************************

	/** The user clicked the first (rightmost) button on the dialog or sheet. */
	public static var NSFirstButton:NSAlertReturn = new NSAlertReturn(1000);

	/** The user clicked the second button from the right edge of the dialog or sheet. */
	public static var NSSecondButton:NSAlertReturn = new NSAlertReturn(1001);

	/** The user clicked the third button from the right edge of the dialog or sheet. */
	public static var NSThirdButton:NSAlertReturn = new NSAlertReturn(1002);

	private function NSAlertReturn(value:Number) {
		super(value);
	}
}
