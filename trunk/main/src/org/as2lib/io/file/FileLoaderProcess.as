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

import org.as2lib.app.exec.AbstractProcess;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.LoadStartListener;
import org.as2lib.io.file.LoadCompleteListener;
import org.as2lib.io.file.LoadProgressListener;
import org.as2lib.io.file.LoadErrorListener;
import org.as2lib.data.holder.Map;
import org.as2lib.app.exec.Executable;

/**
 * {@code FileLoaderProcess} is a mediator to handle loading of files as
 * a {@code Process}.
 * 
 * <p>If you need to handle a {@link FileLoader} with a {@link Process} context
 * you can use {@code FileLoaderProcess} as mediator between both APIs.
 * 
 * <p>In contrast to {@code FileLoader} you have to call it like:
 * <code>
 *   import org.as2lib.io.file.TextFileLoader;
 *   import org.as2lib.io.file.FileLoaderProcess;
 * 
 *   var fileLoader:TextFileLoader = new TextFileLoader();
 *   var loader:FileLoaderProcess = new FileLoaderProcess(fileLoader);
 *   loader.setUri("test.txt");
 *   loader.start();
 * </code>
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.io.file.FileLoaderProcess extends AbstractProcess implements LoadStartListener,
		LoadCompleteListener, LoadProgressListener, LoadErrorListener {
	
	/** Resource loader to be mediated. */
	private var resourceLoader:FileLoader;
	
	/** URI to load. */
	private var uri:String;
	
	/** Parameter submit method for the request. */
	private var method:String;
	
	/** Parameter to be used for the request. */
	private var parameter:Map;
	
	/** {@code Executable} to be called on finish of the process. */
	private var callBack:Executable;
	
	/** Are errors ignored? */
	private var ignoreErrors:Boolean;
			
	/**
	 * Constructs a new {@code FileLoaderProcess}.
	 * 
	 * @param resourceLoader {@code FileLoader} to be mediated
	 */
	public function FileLoaderProcess(resourceLoader:FileLoader, ignoreErrors:Boolean) {
		this.resourceLoader = resourceLoader;
		this.ignoreErrors = ignoreErrors ? true : false;
		resourceLoader.addListener(this);
	}
	
	/**
	 * Prepares the instance for loading events.
	 * 
	 * <p>All passed-in parameters will be used to {@code .load} the given
	 * file.
	 * 
	 * @param uri location of the file to load
	 * @param parameters (optional) parameters for loading the file
	 * @param method (optional) POST/GET as method for submitting the parameters,
	 *        default method used if {@code method} was not passed-in is POST.
	 * @param callBack (optional) {@link Executable} to be executed after the
	 *        the resource was loaded.
	 */
	public function setUri(uri:String, method:String, parameter:Map, callBack:Executable):Void {
		this.uri = uri;
		this.method = method;
		this.parameter = parameter;
		this.callBack = callBack;
		if (getName() == null) {
			setName(uri);
		}
	}
	
	/**
	 * Returns the {@code FileLoader} that was mediated.
	 * 
	 * @return {@code FileLoader} that was mediated.
	 */
	public function getFileLoader(Void):FileLoader {
		return resourceLoader;
	}
	
	/**
	 * Implementation of {@code AbstractProcess#run} to handle loading
	 * of the process.
	 */
	public function run() {
		var uri:String = (arguments[0] instanceof String) ? arguments[0] : this.uri;
		var method:String = (arguments[1] instanceof String) ? arguments[1] : this.method;
		var parameter:Map = (arguments[2] instanceof Map) ? arguments[2] : this.parameter;
		var callBack:Executable = (arguments[3] instanceof Executable) ? arguments[3] : this.callBack;
		resourceLoader.load(uri, method, parameter, callBack);
		working = !hasFinished();
	}
	
	/**
	 * Forwards {@code getPercentage} to the mediated {@code FileLoader.getPercentage}.
	 * 
	 * @return percentage of the resource
	 */
	public function getPercentage(Void):Number {
		return resourceLoader.getPercentage();
	}
	
	/**
	 * Handles the inner file loader's start event.
	 * 
	 * @param fileLoader the file loader that distributes the event
	 */
	public function onLoadStart(fileLoader:FileLoader):Void {
		// Start event has already been distributed by the AbstractProcess.prepare method.
		//sendStartEvent();
	}
	
	/**
	 * Handles the inner file loader's complete event.
	 * 
	 * @param fileLoader the file loader that distributes the event
	 */
	public function onLoadComplete(fileLoader:FileLoader):Void {
		finish();
	}
	
	/**
	 * Handles the inner file loader's progress event.
	 * 
	 * @param fileLoader the file loader that distributes the event
	 */
	public function onLoadProgress(fileLoader:FileLoader):Void {
		distributeUpdateEvent();
	}
	
	/**
	 * Handles the inner file loader's error event.
	 * 
	 * @param fileLoader the file loader that distributes the event
	 */
	public function onLoadError(fileLoader:FileLoader, errorCode:String, error):Boolean {
		if (!ignoreErrors) {
			// TODO: Refactor error. Is error argument always the file name?
			interrupt(errorCode + ": " + error.toString());
		}
		else {
			finish();
		}
		// TODO: Why does this event listener consume the error?
		return true;
	}
	
}