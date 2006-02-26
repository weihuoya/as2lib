/* See LICENSE for copyright and terms of use */

import org.actionstep.ASDraw;
import org.actionstep.constants.ASMovieLoopMode;
import org.actionstep.constants.ASMovieStatusType;
import org.actionstep.movie.ASMovieControllerView;
import org.actionstep.NSColor;
import org.actionstep.NSException;
import org.actionstep.NSMovie;
import org.actionstep.NSNotification;
import org.actionstep.NSNotificationCenter;
import org.actionstep.NSRect;
import org.actionstep.NSSize;
import org.actionstep.NSSound;
import org.actionstep.NSView;
import org.actionstep.ASColors;

/**
 * <p>This class is used to display and control an {@link NSMovie} object.</p>
 *
 * <p>Please note that to use this class, the view's window must load in a swf
 * containing a <code>MovieClip</code> named <code>"videoSymbol"</code>. This
 * movieclip must contain a Video instance named <code>video</code>. A swf
 * fitting these descriptions are provided for you by
 * <code>lib/video.swf</code>.</p>
 *
 * @author Scott Hyndman
 */
class org.actionstep.NSMovieView extends NSView {

	//******************************************************
	//*                    Constants
	//******************************************************

	/**
	 * The linkage identifier used by the <code>MovieClip</code> containing the
	 * <code>Video</code> instance.
	 */
	private static var VIDEO_SYMBOL_LINKAGE:String = "videoSymbol";

	//******************************************************
	//*                 Member variables
	//******************************************************

	private var m_movie:NSMovie;
	private var m_movieSound:NSSound;
	private var m_isPlaying:Boolean;
	private var m_isMuted:Boolean;
	private var m_volume:Number;
	private var m_loopMode:ASMovieLoopMode;
	private var m_playsSelectionOnly:Boolean;
	private var m_magnification:Number;
	private var m_isEditable:Boolean;

	private var m_isControllerVisible:Boolean;
	private var m_controller:ASMovieControllerView;

	private var m_movieClip:MovieClip;
	private var m_video:Video;

	private var m_drawsBackground:Boolean;
	private var m_backgroundColor:NSColor;

	//******************************************************
	//*                   Construction
	//******************************************************

	/**
	 * <p>Creates a new instance of the <code>NSMovieView</code> class.</p>
	 *
	 * <p>This should be followed by a call to {@link #init()} or
	 * {@link #initWithFrame()}. </p>
	 */
	public function NSMovieView() {
		m_isPlaying = false;
		m_isMuted = false;
		m_volume = 1.0;
		m_loopMode = ASMovieLoopMode.ASMovieNormalPlayback;
		m_playsSelectionOnly = false;
		m_isControllerVisible = true;
		m_magnification = 1;
		m_isEditable = true;
		m_drawsBackground = true;
		m_backgroundColor = ASColors.lightGrayColor();
	}

	/**
	 * Initializes the movie view with the frame rectangle of
	 * <code>frame</code>.
	 */
	public function initWithFrame(frame:NSRect):NSMovieView {
		super.initWithFrame(frame);

		//
		// Create the controller
		//
		var ctrl:ASMovieControllerView = new ASMovieControllerView();
		ctrl.init();
		setMovieController(ctrl);

		return this;
	}

	//******************************************************
	//*                  View methods
	//******************************************************

	/**
	 * Overridden to remove the "movie" clip.
	 */
	public function removeMovieClips():Void {
		m_movieClip.removeMovieClip();
		m_movieClip = null;

		super.removeMovieClips();
	}

	/**
	 * Fired when the frame changes.
	 */
	private function frameDidChange(oldFrame:NSRect):Void {
		resizeControllerView();
	}

	//******************************************************
	//*                 Setting a movie
	//******************************************************

	/**
	 * Returns the movie displayed by this view.
	 */
	public function movie():NSMovie {
		return m_movie;
	}

	/**
	 * Sets the <code>NSMovie</code> to be displayed by this view to
	 * <code>movie</code>.
	 */
	public function setMovie(movie:NSMovie):Void {
		stopObservingMovie();
		m_movie = movie;
		beginObservingMovie();
	}

	/**
	 * Unregisters this view as an observer of movie events for the current
	 * movie.
	 */
	private function stopObservingMovie():Void {
		var movie:NSMovie = movie();

		if (null == movie) {
			return;
		}

		NSNotificationCenter.defaultCenter().removeObserverNameObject(
			this,
			null,
			movie);
	}

	/**
	 * Registers this view as an observer of movie events for the current
	 * movie.
	 */
	private function beginObservingMovie():Void {
		var movie:NSMovie = movie();

		if (null == movie) {
			return;
		}

		var center:NSNotificationCenter = NSNotificationCenter.defaultCenter();
		center.addObserverSelectorNameObject(
			this,
			"movieDidInitialize",
			NSMovie.ASMovieDidInitialize);
		center.addObserverSelectorNameObject(
			this,
			"movieDidChangeStatus",
			NSMovie.ASMovieStatusDidChangeNotification);
		center.addObserverSelectorNameObject(
			this,
			"movieDidEncounterError",
			NSMovie.ASMovieEncounteredErrorNotification);
	}

	//******************************************************
	//*      Setting the appearance of the movie view
	//******************************************************

	/**
	 * <p>Returns <code>true</code> if the movie view draws a background.</p>
	 *
	 * <p>This method is ActionStep only.</p>
	 *
	 * @see #setDrawsBackground()
	 * @see #backgroundColor()
	 */
	public function drawsBackground():Boolean {
		return m_drawsBackground;
	}

	/**
	 * <p>Sets whether the movie view draws a background.</p>
	 *
	 * <p>This method is ActionStep only.</p>
	 *
	 * @see #drawsBackground()
	 */
	public function setDrawsBackground(flag:Boolean):Void {
		m_drawsBackground = flag;
	}

	/**
	 * <p>Returns the background color of the movie view.</p>
	 *
	 * <p>This method is ActionStep only.</p>
	 *
	 * @see #setBackgroundColor()
	 */
	public function backgroundColor():NSColor {
		return m_backgroundColor;
	}

	/**
	 * <p>Sets the background color of the movie view to <code>color</code>.</p>
	 *
	 * <p>This method is ActionStep only.</p>
	 *
	 * @see #backgroundColor()
	 * @see #drawsBackground()
	 */
	public function setBackgroundColor(color:NSColor):Void {
		m_backgroundColor = color;
	}

	//******************************************************
	//*                 Playing a movie
	//******************************************************

	/**
	 * <p>Sets the playhead to the beginning of the movie.</p>
	 *
	 * <p>If the movie is playing, it continues to play from the new position.</p>
	 */
	public function gotoBeginning(sender:Object):Void {
		var movie:NSMovie = movie();
		if (null == movie) {
			return;
		}

		movie.internalNetStream().seek(0);
	}

	/**
	 * <p>Sets the playhead to the end of the movie.</p>
	 *
	 * <p>This method is only available to movies that contain meta data.</p>
	 *
	 * <p>If the movie is in a loop mode, the movie will continue playing
	 * accordingly. Otherwise it is stopped.</p>
	 */
	public function gotoEnd(sender:Object):Void {
		var movie:NSMovie = movie();
		if (null == movie) {
			return;
		}

		if (!movie.hasMetaData()) {
			asWarning("Movies with no meta data cannot use the NSMovieView" +
			".gotoEnd() method.");
			return;
		}

		movie.internalNetStream().seek(movie.duration());
	}

	/**
	 * Returns <code>true</code> if the movie is playing, or <code>false</code>
	 * otherwise.
	 */
	public function isPlaying():Boolean {
		return m_isPlaying;
	}

	/**
	 * <p>Starts the movie playing at its current location.</p>
	 *
	 * <p>This method does nothing if the movie is already playing.</p>
	 */
	public function start(sender:Object):Void {
		if (isPlaying()) {
			return;
		}

		m_isPlaying = true;

		var movie:NSMovie = movie();
		if (null != movie) {
			movie.internalNetStream().pause(false);
		}
	}

	/**
	 * <p>Sets the playhead of the movie to one frame before the current frame.</p>
	 *
	 * <p>If the movie is playing, it will stop at the new frame.</p>
	 */
	public function stepBack(sender:Object):Void {
		//! TODO Implement
	}

	/**
	 * <p>Sets the playhead of the movie to one frame after the current frame.</p>
	 *
	 * <p>If the movie is playing, it will stop at the new frame.</p>
	 */
	public function stepForward(sender:Object):Void {
		//! TODO Implement
	}

	/**
	 * <p>This action stops the movie.</p>
	 *
	 * <p>If the movie is already stopped, this method does nothing.</p>
	 */
	public function stop(sender:Object):Void {
		if (!isPlaying()) {
			return;
		}

		m_isPlaying = false;

		var movie:NSMovie = movie();
		if (null != movie) {
			movie.internalNetStream().pause(true);
		}
	}

	/**
	 * Returns the frame rate of the movie.
	 */
	public function rate():Number {
		var movie:NSMovie = movie();
		if (null == movie) {
			return null;
		}

		if (!movie.hasMetaData()) {
			return movie.internalNetStream().currentFps;
		} else {
			return movie.frameRate();
		}
	}

	//! TODO (void)gotoPosterFrame:(id)sender
	//! TODO (void)setRate:(float)rate

	//******************************************************
	//*                     Sound
	//******************************************************

	/**
	 * Returns <code>true</code> if the movie's sound is muted, or
	 * <code>false</code> otherwise.
	 *
	 * @see #setMuted()
	 */
	public function isMuted():Boolean {
		return m_isMuted;
	}

	/**
	 * Sets whether the movie's sound is muted. <code>true</code> mutes the
	 * sound, and <code>false</code> plays the sound.
	 *
	 * @see #isMuted()
	 */
	public function setMuted(muted:Boolean):Void {
		if (isMuted() == muted) {
			return;
		}

		m_isMuted = muted;
		updateVolume();
	}

	/**
	 * <p>Returns the volume of the movie.</p>
	 *
	 * <p>Volume is a value from 0.0 to 1.0.</p>
	 *
	 * @see #setVolume()
	 */
	public function volume():Number {
		return m_volume;
	}

	/**
	 * <p>Sets the volume of the movie to <code>volume</code>.</p>
	 *
	 * <p>Volume is value from 0.0 to 1.0.</p>
	 *
	 * @see #volume()
	 */
	public function setVolume(volume:Number):Void {
		if (volume < 0) {
			volume = 0;
		}
		else if (volume > 1) {
			volume = 1;
		}

		m_volume = volume;
		updateVolume();
	}

	/**
	 * <p>Updates the volume of the movie's sound if possible.</p>
	 */
	private function updateVolume():Void {
		if (null == m_movieSound) {
			return;
		}

		if (isMuted()) {
			m_movieSound.setVolume(0);
		} else {
			m_movieSound.setVolume(volume());
		}
	}

	//******************************************************
	//*                   Play modes
	//******************************************************

	/**
	 * <p>Returns the playback behavior of this movie view.</p>
	 */
	public function loopMode():ASMovieLoopMode {
		return m_loopMode;
	}

	/**
	 * <p>Sets the playback of the movie view to <code>loopMode</code>.</p>
	 */
	public function setLoopMode(loopMode:ASMovieLoopMode):Void {
		m_loopMode = loopMode;
	}

	/**
	 * <p>Returns <code>true</code> if the movie view only plays the selected
	 * portion of the movie.</p>
	 */
	public function playsSelectionOnly():Boolean {
		return m_playsSelectionOnly;
	}

	/**
	 * <p>Sets whether only the selected portion of the movie is played to
	 * <code>flag</code>.</p>
	 *
	 * <p>If there is no selection, the entire movie is played.</p>
	 */
	public function setPlaysSelectionOnly(flag:Boolean):Void {
		m_playsSelectionOnly = flag;
	}

	//! TODO (BOOL)playsEveryFrame
	//! TODO (void)setPlaysEveryFrame:(BOOL)flag

	//******************************************************
	//*                Setting controller
	//******************************************************

	/**
	 * Returns the controller view.
	 */
	public function movieController():ASMovieControllerView {
		return m_controller;
	}

	/**
	 * Sets the controller view of the movie view to ctrl.
	 */
	public function setMovieController(ctrl:ASMovieControllerView):Void {
		m_controller.removeFromSuperview();
		m_controller.setMovieView(null);

		m_controller = ctrl;
		ctrl.setMovieView(this);
		addSubview(ctrl);
		resizeControllerView();
	}

	/**
	 * <p>Returns <code>true</code> if the movie controller is visible.</p>
	 *
	 * <p>The default is <code>true</code>.</p>
	 */
	public function isControllerVisible():Boolean {
		return m_isControllerVisible;
	}

	/**
	 * <p>Sets whether the movie controller is shown beneath the movie.</p>
	 *
	 * <p>If <code>adjustSize</code> is <code>true</code>, the height of this
	 * view will be modified so the size of the movie remains unchanged. If
	 * <code>adjustSize</code> if <code>false</code>, the movie will be scaled
	 * to fit within the frame. </p>
	 *
	 * <p>This adjustment is only made if <code>show</code> is different than the
	 * value of {@link #isControllerVisible()}.</p>
	 */
	public function showControllerAdjustingSize(show:Boolean,
			adjustSize:Boolean):Void {
		if (show == isControllerVisible()) {
			return;
		}
	}

	/**
	 * Resizes the controller view to accomodate the current frame.
	 */
	private function resizeControllerView():Void {
		m_controller.setFrame(controllerFrame());
	}

	/**
	 * Returns the rectangle of the controller based on the frame size of the
	 * movie view.
	 */
	private function controllerFrame():NSRect {
		var ctrlHeight:Number = m_controller.preferredHeight();
		var frame:NSRect = frame();
		return new NSRect(0,
			frame.size.height - ctrlHeight,
			frame.size.width,
			ctrlHeight);
	}

	//******************************************************
	//*                     Sizing
	//******************************************************

	/**
	 * Returns the rectangle containing the movie.
	 */
	public function movieRect():NSRect {
		return new NSRect(m_movieClip._x, m_movieClip._y,
			m_movieClip._width, m_movieClip._height);
	}

	/**
	 * Resizes the views frame to the size required to display the movie with
	 * a magnification of <code>magnification</code> and a movie controller
	 * beneath it.
	 *
	 * @see #sizeForMagnification()
	 */
	public function resizeWithMagnification(magnification:Number):Void {
		setFrameSize(sizeForMagnification(magnification));
	}

	/**
	 * <p>Returns the size that would be required for this movie view if it was
	 * magnified by <code>magnification</code>.</p>
	 *
	 * <p>An extra 16 pixels are added to the vertical dimension to allow room for
	 * the movie controller, even if it is currently hidden.</p>
	 *
	 * @see #resizeWithMagnification()
	 */
	public function sizeForMagnification(magnification:Number):NSSize {
		var movieSize:NSSize = movieRect().size;
		movieSize.width /= m_magnification * magnification;
		movieSize.height /= m_magnification * magnification
			+ movieController().preferredHeight();

		return movieSize;
	}

	//******************************************************
	//*                    Editing
	//******************************************************

	/**
	 * <p>Returns <code>true</code> if the movie is editable.</p>
	 *
	 * <p>When a movie is editable, the {@link #clear()}, {@link #cut()},
	 * {@link #copy()}, {@link #delete()} and {@link #paste()}
	 * operations will be available. In addition, you will able to drag movies
	 * onto the view to replace the currently playing movie.</p>
	 *
	 * <p>The default is <code>true</code>.</p>
	 *
	 * @see #setEditable()
	 */
	public function isEditable():Boolean {
		return m_isEditable;
	}

	/**
	 * Sets whether the movie can be edited to <code>editable</code>.
	 *
	 * @see #isEditable()
	 */
	public function setEditable(editable:Boolean):Void {
		m_isEditable = editable;
	}

	// I'm pretty sure these methods are only really possible through tricks
	//! TODO (void)selectAll:(id)sender
	//! TODO (void)clear:(id)sender
	//! TODO (void)copy:(id)sender
	//! TODO (void)cut:(id)sender
	//! TODO (void)delete:(id)sender
	//! TODO (void)paste:(id)sender

	//******************************************************
	//*             Handling movie notifications
	//******************************************************

	/**
	 * Fired when the movie finishes initializing.
	 */
	private function movieDidInitialize(ntf:NSNotification):Void {
		if (isPlaying()) {
			movie().internalNetStream().pause(false);
		}
	}

	/**
	 * Fired when the movie status changes.
	 */
	private function movieDidChangeStatus(ntf:NSNotification):Void {
		var status:ASMovieStatusType = ASMovieStatusType(
			ntf.userInfo.objectForKey("ASMovieStatusChange"));

		//
		// Check if we should loop
		//
		if (ASMovieStatusType.ASBufferFlush == status
				&& loopMode() == ASMovieLoopMode.ASMovieLoopingPlayback) {
			gotoBeginning();
			//!FIXME This doesn't work properly
		}
	}

	/**
	 * Fired when the movie encounters an error.
	 */
	private function movieDidEncounterError(ntf:NSNotification):Void {

	}

	//******************************************************
	//*                  Drawing the view
	//******************************************************

	/**
	 * Draws the movie view inside the area defined by <code>rect</code>.
	 */
	public function drawRect(rect:NSRect):Void {
		//
		// Create the movie symbol if we don't have one yet.
		//
		if (null == m_movieClip) {
			var depth:Number = getNextDepth();
			m_movieClip = m_mcBounds.attachMovie(VIDEO_SYMBOL_LINKAGE,
				"m_movieClip", depth);

			//
			// If we weren't able to attach the movie symbol, throw an
			// exception. The root window swf must not be one that contains
			// a videoSymbol.
			//
			if (null == m_movieClip) {
				var e:NSException = NSException.exceptionWithNameReasonUserInfo(
					NSException.NSGeneric,
					"The NSMovieView was not able to attach the movieclip " +
					"with the linkage " + VIDEO_SYMBOL_LINKAGE + ". Make " +
					"sure your window is initialized with a swf containing " +
					"this symbol.",
					null);
				trace(e);
				throw e;
			}

			m_video = Video(m_movieClip.video);

			//
			// If we weren't able to get the the Video instance, throw an
			// exception.
			//
			if (null == m_video) {
				var e:NSException = NSException.exceptionWithNameReasonUserInfo(
					NSException.NSGeneric,
					"The NSMovieView was not able to obtain the video " +
					"instance named video from the MovieClip with the " +
					"linkage " + VIDEO_SYMBOL_LINKAGE + ". Make " +
					"sure your window is initialized with a swf containing " +
					"this symbol.",
					null);
				trace(e);
				throw e;
			}

			//
			// Associate the new movieclips with the view
			//
			m_movieClip.view = this;
			m_video["view"] = this;

			//
			// Attach the audio so we can control the sound.
			//
			m_movieClip.attachAudio(m_movie.internalNetStream());
			m_movieSound = (new NSSound()).initWithSound(
				new Sound(m_movieClip));
			updateVolume();

			//
			// Attach the video
			//
			m_video.attachVideo(m_movie.internalNetStream());
		}

		var mc:MovieClip = mcBounds();
		mc.clear();

		//
		// Draw the background color
		//
		if (drawsBackground()) {
			var color:NSColor = backgroundColor();
			ASDraw.fillRectWithRect(mc, rect, color.value);
		}

		//! FIXME This is wrong. We're not scaling proportionately
		m_movieClip._width = rect.size.width;

		if (isControllerVisible()) {
			m_movieClip._height = rect.size.height
				- movieController().preferredHeight();
		} else {
			m_movieClip._height = rect.size.height;
		}

		m_controller.setNeedsDisplay(true);
	}
}