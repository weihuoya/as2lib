/* See LICENSE for copyright and terms of use */

import org.actionstep.NSView;
import org.actionstep.NSMovieView;
import org.actionstep.NSRect;
import org.actionstep.ASDraw;
import org.actionstep.NSButton;
import org.actionstep.NSFont;
import org.actionstep.constants.NSButtonType;
import org.actionstep.NSCell;
import org.actionstep.layout.ASHBox;

/**
 * This view provides controls to control the playback of an 
 * <code>NSMovieView</code>.
 * 
 * @author Scott Hyndman
 */
class org.actionstep.movie.ASMovieControllerView extends NSView {
	
	//******************************************************															 
	//*                  Member variables
	//******************************************************
	
	private var m_movieView:NSMovieView;
	private var m_playButton:NSButton;
	private var m_muteButton:NSButton;
	
	//******************************************************															 
	//*                    Construction
	//******************************************************
	
	/**
	 * Creates a new instance of the <code>ASMovieControllerView</code> class.
	 */
	public function ASMovieControllerView() {	
	}
	
	/**
	 * Initializes the movie controller with a frame rectangle of 
	 * <code>frame</code>.
	 */
	public function initWithFrame(frame:NSRect):ASMovieControllerView {
		super.initWithFrame(frame);
		
		//
		// Create child components
		//
		var hbox:ASHBox = (new ASHBox()).init();
		hbox.setBorder(3);
		addSubview(hbox);
		
		//
		// Play button
		//
		m_playButton = new NSButton();
		m_playButton.initWithFrame(new NSRect(0,0,70,20));
		m_playButton.setTarget(this);
		m_playButton.setAction("didClickPlay");
		m_playButton.setFont(NSFont.systemFontOfSize(9));
		m_playButton.setTitle("Play");
		m_playButton.setAlternateTitle("Pause");
		m_playButton.setButtonType(NSButtonType.NSToggleButton);
		hbox.addView(m_playButton);
		
		//
		// Mute button
		//
		m_muteButton = new NSButton();
		m_muteButton.initWithFrame(new NSRect(0,0,70,20));
		m_muteButton.setTarget(this);
		m_muteButton.setAction("didClickMute");
		m_muteButton.setFont(NSFont.systemFontOfSize(9));
		m_muteButton.setTitle("Mute");
		m_muteButton.setAlternateTitle("Unmute");
		m_muteButton.setButtonType(NSButtonType.NSToggleButton);
		hbox.addView(m_muteButton);
		
		return this;
	}
	
	//******************************************************															 
	//*              Setting the movie view
	//******************************************************
	
	/**
	 * Returns the movie view this view is controlling.
	 */
	public function movieView():NSMovieView {
		return m_movieView;
	}
	
	/**
	 * Sets the movie view that this view should control to 
	 * <code>movieView</code>.
	 */
	public function setMovieView(movieView:NSMovieView):Void {
		m_movieView = movieView;
	}
	
	//******************************************************															 
	//*           Getting the preferred height
	//******************************************************
	
	/**
	 * Returns the preferred height of the controller.
	 * 
	 * This should be overridden in subclasses.
	 */
	public function preferredHeight():Number {
		return 30;
	}
	
	//******************************************************															 
	//*                 Drawing the view
	//******************************************************
	
	/**
	 * Draws the movie controller in the area defined by <code>rect</code>.
	 */
	public function drawRect(rect:NSRect):Void {
		var mc:MovieClip = mcBounds();
		mc.clear();
		ASDraw.fillRectWithRect(mc, rect, 0xCCCCCC);
	}
	
	//******************************************************															 
	//*               Responding to actions
	//******************************************************
	
	/**
	 * Fired when the play button is clicked.
	 */
	private function didClickPlay(playButton:NSButton):Void {
		var state:Number = playButton.state();
		
		if (state == NSCell.NSOnState) {
			movieView().start(this);
		} else {
			movieView().stop(this);
		}
	}
	
	/**
	 * Fired when the mute button is clicked.
	 */
	private function didClickMute(muteButton:NSButton):Void {
		var state:Number = muteButton.state();
		
		if (state == NSCell.NSOnState) {
			movieView().setMuted(true);
		} else {
			movieView().setMuted(false);
		}
	}
}