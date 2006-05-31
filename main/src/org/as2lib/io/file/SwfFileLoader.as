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

import org.as2lib.app.exec.Executable;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.Map;
import org.as2lib.data.type.Byte;
import org.as2lib.data.type.Time;
import org.as2lib.env.event.impulse.FrameImpulse;
import org.as2lib.env.event.impulse.FrameImpulseListener;
import org.as2lib.io.file.AbstractFileLoader;
import org.as2lib.io.file.File;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.FileNotLoadedException;
import org.as2lib.io.file.SwfFile;

/**
 * {@code SwfFileLoader} is a implementation of {@link FileLoader} to load
 * files with {@code loadMovie} (usually {@code .swf} files}.
 * 
 * <p>Any content to be loaded with {@code MovieClip#loadMovie} can be load with
 * {@code SwfLoader} to a concrete {@code MovieClip} instance that has to be
 * passed-in with the constructor.
 * 
 * <p>{@code SwfLoader} represents the time consuming part of accessing external
 * {@code .swf}' ({@code SwfFile} is the handleable part} and therefore
 * contains a event system to add listeners to listen to the concrete events.
 * It is possible to add listeners using {@code addListener}.
 * 
 * <p>Example listener:
 * <code>
 *   import org.as2lib.io.file.AbstractFileLoader;
 *   import org.as2lib.io.file.LoadProgressListener;
 *   import org.as2lib.io.file.LoadStartListener;
 *   import org.as2lib.io.file.LoadCompleteListener;
 *   import org.as2lib.io.file.LoadErrorListener;
 *   import org.as2lib.io.file.FileLoader;
 *   import org.as2lib.io.file.SwfFile;
 *   
 *   class MySwfListener implements 
 *        LoadProgressListener, LoadStartListener,
 *        LoadCompleteListener, LoadErrorListener {
 *        
 *     public function onLoadComplete(fileLoader:FileLoader):Void {
 *       var swf:SwfFile = SwfFile(fileLoader.getFile());
 *       if (swf != null) {
 *         // Proper swf available
 *       } else {
 *         // Wrong event handled
 *       }
 *     }
 *     
 *     public function onLoadError(fileLoader:FileLoader, errorCode:String, error):Boolean {
 *       if (errorCode == AbstractFileLoader.FILE_NOT_FOUND) {
 *         var notExistantUrl = error;
 *         // Use that url
 *       }
 *       return false;
 *     }
 *     
 *     public function onLoadStart(fileLoader:FileLoader):Void {
 *       // show that this file just gets loaded
 *     }
 *     
 *     public function onLoadProgress(fileLoader:FileLoader):Void {
 *       // update the percentage display with fileLoader.getPercentage();
 *     }
 *   }
 * </code>
 * 
 * <p>Example of the usage:
 * <code>
 *   import org.as2lib.io.file.SwfFileLoader;
 *   
 *   var container:MovieClip = this.createEmptyMovieClip("container", 1);
 *   var swfLoader:SwfFileLoader = new SwfFileLoader(container);
 *   swfLoader.addListener(new MySwfListener());
 *   swfLoader.load("test.swf");
 * </code>
 * 
 * @author Martin Heidegger
 * @version 1.1
 */
class org.as2lib.io.file.SwfFileLoader extends AbstractFileLoader
	implements FileLoader, FrameImpulseListener {
	
	/** Time until the method breaks with "File not found". */
	public static var TIMEOUT:Time = new Time(3000);
	
	/** Movie clip to load the file into. */
	private var movieClip:MovieClip;
	
	/** The loaded swf file. */
	private var swfFile:SwfFile;
	
    /** Holding former file size for progress event */
    private var formerLoaded:Number;
	
	/**
	 * Constructs a new {@code SwfFileLoader} instance.
	 * 
	 * @param movieClip the movie clip to load the file into
	 */
	public function SwfFileLoader(movieClip:MovieClip) {
		this.movieClip = movieClip;
	}
	
	/**
	 * Sets the movie clip to load the file into.
	 * 
	 * @param movieClip the movie clip to load the file into
	 */
	public function setMovieClip(movieClip:MovieClip):Void {
		this.movieClip = movieClip;
	}
	
	/**
	 * Loads a certain {@code .swf} by a http request.
	 * 
	 * <p>It sends http request by using the passed-in {@code uri}, {@code method}
	 * and {@code parameters} with {@code .loadMovie}. 
	 * 
	 * <p>If you only need to listen if the {@code SwfFile} finished loading
	 * you can apply a {@code callBack} that gets called if the {@code File} is loaded.
	 * 
	 * @param uri location of the file to load
	 * @param parameters (optional) parameters for loading the file
	 * @param method (optional) POST/GET as method for submitting the parameters,
	 *        default method used if {@code method} was not passed-in is POST.
	 * @param callBack (optional) {@link Executable} to be executed after the
	 *        the file was loaded.
	 */
	public function load(uri:String, method:String, parameters:Map, callBack:Executable):Void {
		super.load(uri, method, parameters, callBack);
		swfFile = null;
		endTime = null;
		if(parameters) {
			var keys:Iterator = parameters.keyIterator();
			while (keys.hasNext()) {
				var key = keys.next();
				movieClip[key.toString()] = parameters.get(key);
			}
		}
		movieClip.loadMovie(uri, method);
		sendStartEvent();
		FrameImpulse.getInstance().addFrameImpulseListener(this);
	}
	
	/**
	 * Returns the loaded file.
	 * 
	 * @return file that has been loaded
	 * @throws FileNotLoadedException if the file has not been loaded yet
	 */
	public function getFile(Void):File {
		return getSwfFile();
	}
	
	/**
	 * Returns the loaded swf file.
	 * 
	 * @return the loaded swf file
	 * @throws FileNotLoadedException if the swf file has not been loaded yet
	 */
	public function getSwfFile(Void):SwfFile {
		if (!swfFile) {
			throw new FileNotLoadedException("Swf file has not been loaded yet.", this, arguments);
		}
		return swfFile;
	}
	
	/**
	 * Returns the total amount of bytes that has been loaded.
	 * 
	 * <p>Returns {@code null} if its not possible to get the loaded bytes.
	 * 
	 * @return amount of bytes that has been loaded
	 */
	public function getBytesLoaded(Void):Byte {
		var result:Number = movieClip.getBytesLoaded();
		if (result >= 0) {
			return new Byte(result);
		}
		return null;
	}
	
	/**
	 * Returns the total amount of bytes that will approximately be loaded.
	 * 
	 * <p>Returns {@code null} if its not possible to get the total amount of bytes.
	 * 
	 * @return amount of bytes to load
	 */
	public function getBytesTotal(Void):Byte {
		var total:Number = movieClip.getBytesTotal();
		if (total >= 0) {
			return new Byte(total);
		}
		return null;
	}
	
	/**
	 * Handles a {@code frame} execution.
	 * 
	 * <p>Helper that checks every frame if the {@code .swf} finished loading.
	 * 
	 * @param impulse {@code FrameImpulse} that sent the event
	 */
	public function onFrameImpulse(impulse:FrameImpulse):Void {
		if (checkFinished()) {
			successLoading();
			return;
		}
		if (checkTimeout()) {
			failLoading();
		}
	}
	
	/**
	 * Checks if the {@code .swf} finished loading.
	 * 
	 * @return {@code true} if the {@code .swf} finished loading
	 */
    private function checkFinished():Boolean {
            movieClip = eval("" + movieClip._target);
            var total:Number = movieClip.getBytesTotal();
            var loaded:Number = movieClip.getBytesLoaded();
            if (total > 10 && total - loaded < 10) {
                    formerLoaded = loaded;
                    return true;
            }
            if (loaded != formerLoaded) {
                if (loaded > 0) {
                    sendProgressEvent();
                }
                formerLoaded = loaded;
            }
            return false;
    }	
	/**
	 * Checks if the {@code TIMEOUT} has been exceeded by the durating.
	 * 
	 * @return {@code true} if the duration exceeded the {@code TIMEOUT} value
	 */
	private function checkTimeout():Boolean {
		if (movieClip.getBytesTotal() > 10) {
			return false;
		}
		return (getDuration().valueOf() > TIMEOUT);
	}
	
	/**
	 * Handles if the loading of file was successful.
	 */
	private function successLoading(Void):Void {
		finished = true;
		started = false;
		swfFile = new SwfFile(movieClip, uri, getBytesTotal());
		endTime = getTimer();
		sendCompleteEvent();
		tearDown();
	}
	
	/**
	 * Handles if the loading of the file failed.
	 */
	private function failLoading(Void):Void {
		finished = true;
		started = false;
		endTime = getTimer();
		sendErrorEvent(FILE_NOT_FOUND_ERROR, uri);
		tearDown();
	}
	
	/**
	 * Removes instance from listening to {@code FrameImpulse}.
	 * 
	 * @see #onFrameImpulse
	 */
	private function tearDown(Void):Void {
		FrameImpulse.getInstance().removeListener(this);
	}

}