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

import org.as2lib.io.file.FileFactory;
import org.as2lib.io.file.File;
import org.as2lib.io.file.Resource;
import org.as2lib.data.type.Byte;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.Map;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.io.file.ResourceLoader;
import org.as2lib.io.file.AbstractResourceLoader;
import org.as2lib.io.file.SimpleFileFactory;
import org.as2lib.io.file.ResourceNotLoadedException;
import org.as2lib.app.exec.Executable;

/**
 * {@code FileLoader} is a implementation of {@link ResourceLoader} for text resources.
 * 
 * <p>Any ASCII/Unicode readable resource is ment as "Text resource". {@code FileLoader}
 * is a implementation for those resources and generates a {@code File} implementation
 * with the loaded content.
 * 
 * <p>{@link FileFactory} allows to generate different {@code File} implementations
 * for the loaded content.
 * 
 * <p>{@code FileLoader} represents the time consuming part of accessing files
 * and therefore contains a event system to add listeners to listen to the
 * concrete events. It is possible to add listeners using {@code addListener}.
 * 
 * <p>Example listener:
 * <code>
 *   import org.as2lib.io.file.AbstractResourceLoader;
 *   import org.as2lib.io.file.LoadProgressListener;
 *   import org.as2lib.io.file.LoadStartListener;
 *   import org.as2lib.io.file.LoadCompleteListener;
 *   import org.as2lib.io.file.LoadErrorListener;
 *   import org.as2lib.io.file.ResourceLoader;
 *   import org.as2lib.io.file.Resource;
 *   
 *   class MyFileListener implements 
 *        LoadProgressListener, LoadStartListener,
 *        LoadCompleteListener, LoadErrorListener {
 *        
 *     public function onLoadComplete(resourceLoader:ResourceLoader):Void {
 *       var file:File = File(resourceLoader.getResource());
 *       if (file != null) {
 *         // Proper file available
 *       } else {
 *         // Wrong event handled
 *       }
 *     }
 *     
 *     public function onLoadError(resourceLoader:ResourceLoader, errorCode:String, error):Void {
 *       if (errorCode == AbstractResourceLoader.FILE_NOT_FOUND) {
 *         var notExistantUrl = error;
 *         // Use that url
 *       }
 *     }
 *     
 *     public function onLoadStart(resourceLoader:ResourceLoader) {
 *       // show that this file just gets loaded
 *     }
 *     
 *     public function onLoadProgress(resourceLoader:ResourceLoader) {
 *       // update the percentage display with resourceLoader.getPercentage();
 *     }
 *   }
 * </code>
 * 
 * <p>Example of the usage:
 * <code>
 *   import org.as2lib.io.file.FileLoader;
 *   
 *   var fileLoader:FileLoader = new FileLoader();
 *   fileLoader.addListener(new MyFileListener());
 *   fileLoader.load("uri");
 * </code>
 * 
 * @author Martin Heidegger
 * @version 1.1
 */
class org.as2lib.io.file.FileLoader extends AbstractResourceLoader implements ResourceLoader {
	
	/** {@code LoadVars} instance for loading the content. */
	private var helper:LoadVars;
	
	/** Result of the loaded {@code uri}. */
	private var file:File;
	
	/** Factory to create the concrete {@code File} instances. */
	private var fileFactory:FileFactory;
	
	/**
	 * Constructs a new {@code FileLoader}.
	 * 
	 * @param fileFactory (optional) {@code FileFactory to create the {@code File}
	 *        implementations, {@link SimpleFileFactory} gets used if no custom
	 *        {@code FileFactory} gets passed-in
	 */
	public function FileLoader(fileFactory:FileFactory) {
		if (!fileFactory) {
			fileFactory = new SimpleFileFactory();
		}
		this.fileFactory = fileFactory;
	}
	
	/**
	 * Loads a certain file by a http request.
	 * 
	 * <p>It sends http request by using the passed-in {@code uri}, {@code method}
	 * and {@code parameters}. The responding file will be passed to the set
	 * {@code FileFactory}.
	 * 
	 * <p>If you only need to listen if the {@code File} finished loading you can
	 * apply a {@code callBack} that gets called if the {@code File} is loaded.
	 * 
	 * @param uri location of the resource to load
	 * @param parameters (optional) parameters for loading the resource
	 * @param method (optional) POST/GET as method for submitting the parameters,
	 *        default method used if {@code method} was not passed-in is POST.
	 * @param callBack (optional) {@link Executable} to be executed after the
	 *        the resource was loaded.
	 */
	public function load(uri:String, method:String, parameters:Map, callBack:Executable):Void {
		super.load(uri, method, parameters, callBack);
		initHelper();
		if (uri == null) {
			throw new IllegalArgumentException("Url has to be set for starting the process.", this, arguments);
		} else {
			if (parameters) {
				if (method == "POST") {
					var keys:Iterator = parameters.keyIterator();
					while (keys.hasNext()) {
						var key = keys.next();
						helper[key.toString()] = parameters.get(key);
					}
					helper.sendAndLoad(uri, this, method);
				} else {
					var result:String = uri;
					if (uri.indexOf("?") == -1) {
						result += "?";
					}
					var keys:Iterator = parameters.keyIterator();
					while (keys.hasNext()) {
						var key = keys.next();
						uri += _global.encode(key.toString()) + "=" + _global.encode(parameters.get(key).toString());
					}
					helper.load(uri);
				}
			} else {
				helper.load(uri);
			}
			sendStartEvent();
		}
	}
	
	/**
	 * Returns the loaded resource.
	 * 
	 * @return resource that has been loaded
	 * @throws ResourceNotLoadedException if the resource has not been loaded yet.
	 */
	public function getResource(Void):Resource {
		return getFile();
	}
	
	/**
	 * Returns the loaded {@code File}.
	 * 
	 * @return {@code File} that has been loaded
	 * @throws ResourceNotLoadedException if the resource has not been loaded yet.
	 */
	public function getFile(Void):File {
		if (file == null) {
			throw new ResourceNotLoadedException("No File has been loaded.", this, arguments);
		}
		return file;
	}
	
	/**
	 * Prepares the helper property {@link helper} for the loading process.
	 */
	private function initHelper(Void):Void {
		var owner:FileLoader = this;
		helper = new LoadVars();
		// Watching _bytesLoaded allows realtime events
		helper.watch(
			"_bytesLoaded",
			function(prop, oldValue, newValue) {
				// Prevent useless events.
				if(newValue != oldValue && newValue > 0) {
					owner["handleUpdateEvent"]();
				}
				return newValue;
			}
		);
		
		// Using LoadVars Template to get the onData Event.
		helper.onData = function(data) {
			owner["handleDataEvent"](data);
		};
	}
	
	/**
	 * Returns the total amount of bytes that has been loaded.
	 * 
	 * <p>Returns {@code null} if its not possible to get the loaded bytes.
	 * 
	 * @return amount of bytes that has been loaded
	 */
	public function getBytesLoaded(Void):Byte {
		var result:Number = helper.getBytesLoaded();
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
		var total:Number = helper.getBytesTotal();
		if (total >= 0) {
			return new Byte(total);
		}
		return null;
	}
	
	/**
	 * Handles a update event from the helper.
	 * 
	 * @see #initHelper
	 */
	private function handleUpdateEvent(Void):Void {
		sendProgressEvent();
	}
	
	/**
	 * Handles a data event from the helper.
	 * 
	 * @see #initHelper
	 */
	private function handleDataEvent(data:String):Void {
		finished = true;
		started = false;
		endTime = getTimer();
		helper.onLoad = function() {};
		helper.unwatch("_bytesLoaded");
		// Check if the file was not available.
		if(typeof data == "undefined") {
			// Dispatching the event for the missing uri.
			sendErrorEvent(FILE_NOT_FOUND_ERROR, uri);
		} else {
			// Correct replacing of special line breaks that don't match the "\n" (Windows & Mac Line Breaks).
			file = fileFactory.createFile(data, getBytesTotal(), uri);
			// Dispatching the event for the loaded file.
			sendCompleteEvent();
		}
	}
}