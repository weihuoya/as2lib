/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import org.as2lib.core.BasicClass;
import org.as2lib.env.event.broadcaster.EventBroadcaster;
import org.as2lib.env.event.broadcaster.SpeedEventBroadcaster;
import org.as2lib.io.file.File;
import org.as2lib.io.file.ByteFormat;
import org.as2lib.io.file.FileListener;
import org.as2lib.io.file.FileEventInfo;
import org.as2lib.io.file.FileNotLoadedException;
import org.as2lib.util.StringUtil;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * Default implementation of a file used within ActionScript.
 * Supports all common features without any advantages.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.io.file.SimpleFile extends BasicClass implements File {
	
	/** Helper XML, rudimentary for the workaround to create a methology like a "file", supports different behaviours */
	private var helperXML:XML;
	
	/** Content of the file */
	private var data:String;
	
	/** Location that has been loaded */
	private var url:String;
	
	/** Flag if the file has been loaded */
	private var loaded:Boolean = false;
	
	/** Flag if the file is currently loading */
	private var loading:Boolean = false;
	
	/** Flag if the file does exist */
	private var doesExist:Boolean = false;
	
	/** Holder for the amount of bytes loaded */
	private var bytesLoaded:Number;
	
	/** Holder for the amount of the total file size */
	private var bytesTotal:Number;
	
	/** Content seperated in lines */
	private var lines:Array;
	
	/** Eventbroadcaster to broadcast events */
	private var eB:EventBroadcaster;
	
	/**
	 * Constructs a new simple file.
	 * It prepares the helperXML and resets all states.
	 */
	public function SimpleFile(Void) {
		eB = new SpeedEventBroadcaster();
		
		helperXML = new XML();
		helperXML["owner"] = this;
		
		// _bytesLoaded listening to create the "onProgress" event.
		helperXML.watch(
			"_bytesLoaded",
			function(prop, oldValue, newValue) {
				// Prevent useless events.
				if(newValue != oldValue && newValue > 0) {
					this.owner.sendProgressEvent(newValue);
				}
				return newValue;
			}
		);
		
		// Using XML Template to get the onData Event.
		helperXML.onData = function(data) {
			this.owner.sendDataEvent(data);
		}
		
		reset();
	}
	
	/**
	 * Resets all states of the Simple File
	 */
	private function reset(Void):Void {
		bytesLoaded = 0;
		bytesTotal = 0;
		loading = false;
		loaded = false;
		doesExist = false;
		lines = null;
		data = null;
	}
	
	/**
	 * Internal method to handle the helperXML's onData Event.
	 * This method will send the onLoad event if the data is valid, else it will send the onFileNotFound event.
	 * 
	 * @param data Content of the file
	 */
	private function sendDataEvent(data:String):Void {
		loading = false;
		loaded = true;
		// Check if the file was not available.
		if(typeof data == "undefined") {
			doesExist = false;
			updateByteInfo();
			// Dispatching the event.
			eB.dispatch(new FileEventInfo("onFileNotFound", this));
		} else {
			doesExist = true;
			updateByteInfo();
			// Correct replacing of special line breaks that don't match the "\n" (Windows & Mac Line Breaks).
			this.data = StringUtil.replace(StringUtil.replace(data, "\u000D\u000A", "\n"), "\u000D", "\n");
			// Dispatching the event.
			eB.dispatch(new FileEventInfo("onLoad", this));
		}
	}
	
	/**
	 * Internal method to handle changes in helperXML bytesLoaded event.
	 * This method will send a onProgress event.
	 *
	 * @param newBytesLoaded 
	 * @see #SimpleFile
	 */
	private function sendProgressEvent(newBytesLoaded:Number):Void {
		doesExist = true;
		bytesLoaded = newBytesLoaded;
		bytesTotal = helperXML.getBytesTotal();
		eB.dispatch(new FileEventInfo("onProgress", this));
	}
	
	/**
	 * Internal method to keep the bytesLoaded and Bytes Total values up-to-date.
	 * This method was used for sendProgressEvent that sets the status of bytesLoaded. 
	 * Else it could be possible by simply setting getting the helperXML.getBytesLoaded/-Total value on request.
	 */
	private function updateByteInfo(Void):Void {
		bytesLoaded = helperXML.getBytesLoaded();
		bytesTotal = helperXML.getBytesTotal();
	}
	
	/**
	 * Implementation of File.load.
	 * 
	 * @param url URL to be loaded.
	 * @see File#load
	 */
	public function load(url:String):Void {
		reset();
		this.url = url;
		loading = true;
		helperXML.load(url);
	}
	
	/**
	 * Implementation of File.isLoading.
	 * 
	 * @return true if the File is still loading.
	 * @see File#isLoading
	 */
	public function isLoading(Void):Boolean {
		return loading;
	}
	
	/**
	 * Implementation of File.isLoaded.
	 * 
	 * @return true if the File is already loaded.
	 * @see File#isLoaded
	 */
	public function isLoaded(Void):Boolean {
		return loaded;
	}
	
	/**
	 * Implementation of File.exists.
	 * This is a low level implementation of .exists. It won't work properly if you didn't load a file before.
	 * 
	 * @throws FileNotLoadedException if no file was loaded before. (Is related to the onLoad event.)
	 * @return true if the file exists.
	 * @see File#exists
	 */
	public function exists(Void):Boolean {
		if(!loaded && !doesExist) {
			throw new FileNotLoadedException("You have to load a file with .load before exists can return a valid result. (Note: Even then it has a delay until the first bytes are loaded.)", this, arguments);
		}
		return doesExist;
	}
	
	/**
	 * Implementation of File.getBytesLoaded.
	 * 
	 * @return Total amount of bytes loaded.
	 * @see File#getBytesLoaded
	 */
	public function getBytesLoaded(Void):Number {
		return bytesLoaded;
	}
	
	/**
	 * Implementation of File.getBytesTotal.
	 * 
	 * @return Total file size in bytes.
	 * @see File#getBytesTotal
	 */
	public function getBytesTotal(Void):Number {
		return bytesTotal;
	}
	
	/**
	 * Implementation of File.getLocation.
	 * 
	 * @return Recent loaded location.
	 * @see File#getLocation
	 */
	public function getLocation(Void):String {
		return url;
	}
	
	/**
	 * Implementation of File.getContent.
	 * 
	 * @return Content of the File (if the file is loaded, else "null")
	 * @see File#getContent
	 */
	public function getContent(Void):String {
		return data;
	}
	
	/**
	 * Method to create the lines from the content.
	 */
	private function evaluateLines(Void):Void {
		lines = data.split("\n");
	}
	
	/**
	 * Implementation of File.getLine.
	 * 
	 * @return Content of the requested line, "undefined" if the line doesn't exist.
	 * @see File#getLine
	 */
	public function getLine(line:Number):String {
		if(!lines) {
			evaluateLines();
		}
		return lines[line];
	}
	
	/**
	 * Implementation of File.countLines.
	 * 
	 * @return Total amount of lines in the content.
	 * @see File#countLines
	 */
	public function countLines(Void):Number {
		if(!lines) {
			evaluateLines();
		}
		return lines.length;
	}
	
	/**
	 * Implementation of File.addListener.
	 * 
	 * @param listener Listener to be added to the file.
	 * @see File#addListener
	 */
	public function addListener(listener:FileListener):Void {
		eB.addListener(listener);
	}
	
	/**
	 * Extended Stringifier
	 * 
	 * Example:
	 *  [type org.as2lib.io.file.SimpleFile | Location: MyFile.txt; Size: 12KB; ]
	 * 
	 * @return The file as string.
	 */
	public function toString():String {
		var result:String;
		// without braces around "new ByteFormat.." not MTASC compatible
		result = "[type " + ReflectUtil.getTypeNameForInstance(this)
				 + " | Location: " + getLocation()
				 + "; Size: " + (new ByteFormat(getBytesTotal())).toString(false, 2)
				 + "; ]";
		return result;
	}
}