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
import org.as2lib.data.holder.Map;
import org.as2lib.data.type.Bit;
import org.as2lib.data.type.Byte;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.io.file.ResourceListener;

/**
 * {@code AbstractResourceLoader} contains common implementation for a {@code ResourceLoader}.
 * 
 * <p>Extend {@code AbstractResourceLoader} to implement most methods required
 * for a {@code ResourceLoader}.
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.io.file.AbstractResourceLoader extends AbstractProcess{
	
	/** Event to publish all events to {@link ResourceListener}. */
	private var resourceEvent:ResourceListener;
	
	/** Location for the resource request. */
	private var uri:String;
	
	/** Method to pass resource request parameters. */
	private var method:String = "POST";
	
	/** Parameters to be used for the resource request. */
	private var parameters:Map;
	
	/**
	 * Constructs a new {@code AbstractResourceLoader}
	 * 
	 * <p>Pass all arguments from the extended constructor by using super to 
	 * add the parameters to the instance.
	 * 
	 * @param uri location of the resource to load
	 * @param parameters (optional) parameters for loading the resource
	 * @param method (optional) POST/GET as method for submitting the parameters,
	 *        default method used if {@code method} was not passed-in is POST.
	 */
	function AbstractResourceLoader(uri:String, parameters:Map, method:String) {
		super();
		distributorControl.acceptListenerType(ResourceListener);
		resourceEvent = distributorControl.getDistributor(ResourceListener);
		
		if (uri) {
			setUri(uri);
		}
		
		if (parameters) {
			setParameters(parameters);
		}
		
		if (method) {
			setParameterSubmitMethod(method);
		}
	}
	
	/**
	 * Sets the {@code method} to pass request parameters for the {@code uri}.
	 * 
	 * @param method method to pass request parameters
	 * @throws IllegalArgumentException if the passed-in {@code method} is not
	 *         "get", "post", "GET" or "POST".
	 * @throws IllegalStateException if the process has been started.
	 */
	public function setParameterSubmitMethod(method:String):Void {
		if (hasStarted()) {
			throw new IllegalStateException("Its not allowed to set submit method"
				+ " during loading of the file", this, arguments);
		}
		method = method.toUpperCase();
		if (method == "POST" || method == "GET") {
			this.method = method;
		} else {
			throw new IllegalArgumentException(method+" is no valid type for "
				+ "submitting parameters", this, arguments);
		}
	}
	
	/**
	 * Sets the {@code parameters} for the request to the resource.
	 * 
	 * @param parameters parameters to be passed to be used for the resource request
	 */
	public function setParameters(map:Map):Void {
		if (hasStarted()) {
			throw new IllegalStateException("Its not allowed to set parameters "
				+ "during loading of the file", this, arguments);
		}
		parameters = map;
	}
	
	/**
	 * Sets the location to the resource to load.
	 * 
	 * @param uri location of the resource to load
	 * @throws IllegalStateException if the process has already been started and
	 * 		   is not finished yet
	 */
	public function setUri(uri:String):Void {
		if (hasStarted()) {
			throw new IllegalStateException("Its not allowed to set uri during "
				+ "loading of the file", this, arguments);
		}
		this.uri = uri;
	}
	
	/**
	 * Returns for the location of the resource that was requested to load.
	 * 
	 * @return location of the resource to load
	 */
	public function getUri(Void):String {
		return uri;
	}
	
	/**
	 * Returns the pecentage of the file that has been loaded.
	 * 
	 * <p>Evaluates the current percentage of the execution by using
	 * {@code getBytesTotal} and {@code getBytesLoaded}.
	 * 
	 * <p>Returns {@code null} if the percentage is not evaluable
	 * 
	 * @return percentage of the file that has been loaded
	 */
	public function getPercentage(Void):Number {
		if (hasStarted() || hasFinished()) {
			var percentage:Number = (
				100  
				/ getBytesTotal().getBytes()
				* getBytesLoaded().getBytes()
				);
			if (percentage >= 100) {
				percentage = 100;
			}
			return percentage;
		} else {
			return null;
		}
	}
	/**
	 * Returns the current transfer rate for the execution.
	 * 
	 * <p>Evalutes the transfer rate by using {@code getBytesLoaded} and
	 * {@code getDuration}.
	 * 
	 * @return transfer rate in bit (per second)
	 */
	public function getTransferRate(Void):Bit {
		return new Bit(getBytesLoaded().getBit()/getDuration().inSeconds());
	}

	/**
	 * Stub implementation for the amount of bytes that were loaded.
	 * 
	 * @return {@code null} for not evaluable
	 */
	public function getBytesTotal(Void):Byte {
		return null;
	}
	
	/**
	 * Stub implementation for the amount of bytes to be loaded.
	 * 
	 * @return {@code null} for not evaluable
	 */
	public function getBytesLoaded(Void):Byte {
		return null;
	}
}