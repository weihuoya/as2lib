/* See LICENSE for copyright and terms of use */

import org.actionstep.ASConnection;
import org.actionstep.ASUtils;
import org.actionstep.constants.ASMovieErrorType;
import org.actionstep.constants.ASMovieStatusType;
import org.actionstep.NSCalendarDate;
import org.actionstep.NSDictionary;
//import org.actionstep.NSException;
import org.actionstep.NSNotificationCenter;
import org.actionstep.NSObject;

/**
 * <p>An <code>NSMovie</code> is a wrapper around an FLV movie.</p> 
 * 
 * <p>This movie can be one streamed from an external server like Red5 or Flash 
 * Communication Server, or it can be loaded from an FLV file.</p>
 * 
 * @author Scott Hyndman
 */
class org.actionstep.NSMovie extends NSObject {
	
	//******************************************************															 
	//*                    Constants
	//******************************************************
	
	/**
	 * The level of a status update.
	 */
	private static var LEVEL_STATUS:String	= "status";
	
	/**
	 * The level of an error.
	 */
	private static var LEVEL_ERROR:String	= "error";
	
	//
	// Status codes
	//
	private static var CODE_EMPTY:String 		= "NetStream.Buffer.Empty";
	private static var CODE_FULL:String			= "NetStream.Buffer.Full";
	private static var CODE_FLUSH:String		= "NetStream.Buffer.Flush";
	private static var CODE_START:String		= "NetStream.Play.Start";
	private static var CODE_STOP:String			= "NetStream.Play.Stop";
	private static var CODE_NOTFOUND:String		= "NetStream.Play.StreamNotFound";
	private static var CODE_INVALIDTIME:String	= "NetStream.Seek.InvalidTime";
	private static var CODE_NOTIFY:String		= "NetStream.Seek.Notify";
	
	//******************************************************															 
	//*                  Member variables
	//******************************************************
	
	private var m_connection:ASConnection;
	private var m_url:String;
	private var m_netStream:NetStream;
	private var m_bufferTime:Number;
	private var m_hasInited:Boolean;
	
	private var m_hasMetaData:Boolean;
	private var m_frameRate:Number;
	private var m_videoDataRate:Number;
	private var m_audioDataRate:Number;
	private var m_height:Number;
	private var m_width:Number;
	private var m_duration:Number;
	private var m_creationDate:NSCalendarDate;

	//******************************************************															 
	//*                   Construction
	//******************************************************
	
	/**
	 * <p>Constructs a new instance of the <code>NSMovie</code> class.</p>
	 * 
	 * <p>Follow this call with {@link #initWithContentsOfURL()} or
	 * {@link #initWithContentsOfConnectionURL()}.</p>
	 */
	public function NSMovie() {
		m_bufferTime = 0.1;
		m_hasMetaData = false;
		m_hasInited = false;
	}
	
	/**
	 * Initializes the movie with the contents of the FLV file found at
	 * <code>url</code>.
	 */
	public function initWithContentsOfURL(url:String):NSMovie {
		m_connection = (new ASConnection()).init();
		m_url = url;
		__init();
		return this;
	}
	
	/**
	 * Initializes the movie with the contents of the FLV file found at
	 * <code>url</code> as accessed through the connection 
	 * <code>connection</code>.
	 */
	public function initWithContentsOfConnectionURL(connection:ASConnection,
			url:String):NSMovie {
		m_connection = connection;		
		m_url = url;
		__init();
		return this;
	}
	
	/**
	 * Creates the <code>NetStream</code> object for this video.
	 */
	private function __init():Void {
		m_netStream = new NetStream(m_connection.internalConnection());
		m_netStream.setBufferTime(m_bufferTime);
		m_netStream.play(m_url);
		
		//
		// Event handlers
		//
		var self:NSMovie = this;
		m_netStream.onMetaData = function(infoObject:Object) {
			self["netStreamHandleMetaData"](infoObject);
		};
		m_netStream.onStatus = function(infoObject:Object) {
			self["netStreamHandleStatus"](infoObject);
		};
	}
	
	//******************************************************															 
	//*                Describing the object
	//******************************************************
	
	/**
	 * Returns a string representation of the movie.
	 */
	public function description():String {
		var ret:String = "NSMovie(URL=" + URL() + ",connection=" + connection();
		
		if (hasMetaData()) {
			ret += ",frameRate=" + frameRate();
			ret += ",duration=" + duration();
			ret += ",videoDataRate=" + videoDataRate();
			ret += ",audioDataRate=" + audioDataRate();
			ret += ",width=" + width();
			ret += ",height=" + height();
		}
		
		ret += ")";
		
		return ret;
	}
	
	//******************************************************															 
	//*                Copying the object
	//******************************************************
	
	/**
	 * Returns a copy of the movie.
	 */
	public function copyWithZone():NSMovie {
		var movie:NSMovie = (new NSMovie()).initWithContentsOfConnectionURL(
			connection(), URL());
			
		//
		// Fill the movie with meta data if possible.
		//
		if (hasMetaData()) {
			movie.m_hasMetaData = true;
			movie.m_frameRate = frameRate();
			movie.m_videoDataRate = videoDataRate();
			movie.m_audioDataRate = audioDataRate();
			movie.m_height = height();
			movie.m_width = width();
			movie.m_duration = duration();
			
			//!FIXME The next line might be wrong.
			movie.m_creationDate = NSCalendarDate(m_creationDate.copyWithZone());
		}
			
		return movie;
	}
	
	//******************************************************															 
	//*             Accessing movie information
	//******************************************************
	
	/**
	 * Returns <code>true</code> if this movie has meta data.
	 */
	public function hasMetaData():Boolean {
		return m_hasMetaData;
	}
	
	/**
	 * Returns the audio data rate of the movie.
	 */
	public function audioDataRate():Number {
		return m_audioDataRate;
	}
	
	/**
	 * Returns the video data rate of the movie.
	 */
	public function videoDataRate():Number {
		return m_videoDataRate;
	}
	
	/**
	 * Returns the duration of the movie, in seconds.
	 */
	public function duration():Number {
		return m_duration;
	}
	
	/**
	 * Returns the frame rate of the movie.
	 */
	public function frameRate():Number {
		return m_frameRate;
	}
	
	/**
	 * Returns the width of the movie, in pixels.
	 */
	public function width():Number {
		return m_width;
	}
	
	/**
	 * Returns the height of the movie, in pixels.
	 */
	public function height():Number {
		return m_height;
	}
	
	/**
	 * Returns the URL of this movie.
	 */
	public function URL():String {
		return m_url;
	}
	
	//******************************************************															 
	//*             Setting the buffer time
	//******************************************************
	
	/**
	 * Returns the number of seconds that videos are buffered before displaying.
	 */
	public function bufferTime():Number {
		return m_bufferTime;
	}
	
	/**
	 * <p>Sets how long (in seconds) to buffer messages before displaying them to 
	 * <code>seconds</code>.</p>
	 * 
	 * <p>The default value is <code>0.1</code>.</p>
	 */
	public function setBufferTime(seconds:Number):Void {
		m_bufferTime = seconds;
		m_netStream.setBufferTime(seconds);
	}
	
	//******************************************************															 
	//*               Internal properties
	//******************************************************
	
	/**
	 * <p>Returns the {@link NetStream} object used internally by this movie.</p>
	 * 
	 * <p>For internal use only.</p>
	 */
	public function internalNetStream():NetStream {
		return m_netStream;
	}
	
	/**
	 * Returns the connection used by this movie.
	 */
	public function connection():ASConnection {
		return m_connection;
	}
	
	//******************************************************															 
	//*               Responding to events
	//******************************************************
	
	/**
	 * Internal event handler for the {@link NetStream#onMetaData} event.
	 */
	private function netStreamHandleMetaData(infoObject:Object):Void {
		m_hasMetaData = true;
		m_frameRate = infoObject.framerate;
		m_audioDataRate = infoObject.audiodatarate;
		m_videoDataRate = infoObject.videodatarate;
		m_height = infoObject.height;
		m_width = infoObject.width;
		m_duration = infoObject.duration;
		m_creationDate = (new NSCalendarDate()).initWithStringCalendarFormat(
			infoObject.creationdate, "%a %b %d %H:%M:%S %Y");
	}
	
	/**
	 * Internal event handler for the {@link NetStream#onStatus} event.
	 */
	private function netStreamHandleStatus(infoObject:Object):Void {
		//
		// If we haven't yet initialized, stop playback.
		//
		if (!m_hasInited && infoObject.code == CODE_START) {
			internalNetStream().pause(true);
			m_hasInited = true;
			
			NSNotificationCenter.defaultCenter().postNotificationWithNameObject(
				ASMovieDidInitialize,
				this);
			
			return;
		}
		
		var isError:Boolean = infoObject.level == LEVEL_ERROR;
		var notType:Number = null;
		var const:Object;
		var userInfo:NSDictionary = NSDictionary.dictionary();
		
		//
		// Determine the constant to use with the notification
		//
		switch (infoObject.code) {
			case CODE_EMPTY:
				const = ASMovieStatusType.ASBufferEmpty;
				break;
				
			case CODE_FLUSH:
				const = ASMovieStatusType.ASBufferFlush;
				break;
				
			case CODE_FULL:
				const = ASMovieStatusType.ASBufferFull;
				break;
				
			case CODE_INVALIDTIME:
				const = ASMovieErrorType.ASMovieInvalidTimeError;
				break;
							
			case CODE_NOTFOUND:
				const = ASMovieErrorType.ASMovieNotFoundError;
				break;
				
			case CODE_NOTIFY:
				const = ASMovieStatusType.ASSeekPerformed;
				break;
				
			case CODE_START:
				const = ASMovieStatusType.ASPlaybackStarted;
				break;
				
			case CODE_STOP:
				const = ASMovieStatusType.ASPlaybackStopped;
				break;			
		}
		
		//
		// Determine the type of notification to dispatch
		//
		if (isError) {
			notType = ASMovieEncounteredErrorNotification;
			userInfo.setObjectForKey(const, "ASMovieErrorType");
		} else {
			notType = ASMovieStatusDidChangeNotification;
			userInfo.setObjectForKey(const, "ASMovieStatusChange");
		}

		//
		// Dispatch the notification
		//	
		try {
			NSNotificationCenter.defaultCenter().postNotificationWithNameObjectUserInfo(
				notType,
				this,
				userInfo);
		} catch (e:Error) {
			asError(e.toString());
		}
	}
	
	//******************************************************															 
	//*                  Notifications
	//******************************************************
	
	/**
	 * Posted to the default notification center when the movie finishes
	 * initializing.
	 */
	public static var ASMovieDidInitialize:Number
		= ASUtils.intern("ASMovieDidInitialize");
		
	/**
	 * <p>Posted to the default notification center when an error is encountered.</p>
	 * 
	 * <p>The userInfo dictionary contains the following:
	 * <ul>
	 * <li>
	 *   "ASMovieErrorType" - The type of error that was encountered. 
	 *   ({@link ASMovieErrorType})
	 *   </li>
	 * </ul>  
	 * </p>
	 */
	public static var ASMovieEncounteredErrorNotification:Number 
		= ASUtils.intern("ASMovieEncounteredErrorNotification");
		
	/**
	 * <p>Posted to the default notification center when a non-error status message
	 * is encountered.</p>
	 * 
	 * <p>The userInfo dictionary contains the following:
	 * <ul>
	 * <li>
	 *   "ASMovieStatusChange" - The type of status message encountered. 
	 *   ({@link ASMovieStatusType})
	 * </li>
	 * </ul>
	 * </p>
	 */
	public static var ASMovieStatusDidChangeNotification:Number
		= ASUtils.intern("ASMovieStatusDidChangeNotification");
}