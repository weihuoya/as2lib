/* See LICENSE for copyright and terms of use */

/**
 * Reserved color names in a theme.
 * 
 * @author Scott Hyndman
 */
class org.actionstep.themes.ASThemeColorNames {
	/**
	 * The NSTable's alternating row color.
	 */
	public static var ASAlternatingRowColor:String = "alternatingRowColor";
	
	/**
	 * The main menu and status bar's background color.
	 */
	public static var ASMainMenuBackground:String = "mainMenuBackgroundColor";
	
	/**
	 * The main color of the progress bar.
	 */
	public static var ASProgressBar:String = "progressBarColor";
	
	/**
	 * The background color of the progress bar.
	 */
	public static var ASProgressBarBackground:String = "progressBarBackgroundColor";
	
	/**
	 * The color of the slider track.
	 */
	public static var ASSliderBarColor:String = "sliderBarColor";
	
	/**
	 * The default color for tab view items.
	 */
	public static var ASTabViewItem:String = "tabViewItemColor";
	
	/**
	 * The color of a browser cell's text when it is not selected. If no
	 * value is provided, black is used.
	 */
	public static var ASBrowserText:String = "browserText";
	
	/**
	 * The color of a browser cell's text when it is selected and is marked
	 * as first responder.
	 */
	public static var ASBrowserFirstResponderSelectionText:String = "browserFirstResponderSelectionText";
	
	/**
	 * The color of a browser cell's background when it is selected and is 
	 * marked as first responder.
	 */
	public static var ASBrowserFirstResponderSelectionBackground:String = "browserFirstResponderSelectionBackground";
	
	/**
	 * <p>The color of browser cell's text when it is selected, but not first
	 * responder.</p>
	 * 
	 * <p>Returns {@link #ASBrowserFirstResponderSelectionText} if 
	 * <code>null</code>.</p>
	 */
	public static var ASBrowserSelectionText:String = "browserSelectionText";
	
	/**
	 * <p>The color of browser cell's background when it is selected, but not 
	 * first responder.</p>
	 * 
	 * <p>Returns {@link #ASBrowserFirstResponderSelectionBackground} if
	 * <code>null</code>.</p> 
	 */
	public static var ASBrowserSelectionBackground:String = "browserSelectionBackground";
	
	/**
	 * <p>The background color for a browser's matrices.</p>
	 * 
	 * <p><code>null</code> if none</p>
	 */
	public static var ASBrowserMatrixBackground:String = "browserMatrixBackground";
}