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

import org.as2lib.data.holder.Map;
import org.as2lib.data.type.Bit;
import org.as2lib.data.type.Byte;
import org.as2lib.env.event.distributor.CompositeEventDistributorControl;
import org.as2lib.io.file.ResourceStartListener;
import org.as2lib.io.file.ResourceCompleteListener;
import org.as2lib.io.file.ResourceProgressListener;
import org.as2lib.io.file.ResourceErrorListener;
import org.as2lib.io.file.ResourceLoader;
import org.as2lib.io.file.Resource;
import org.as2lib.app.exec.Executable;
import org.as2lib.app.exec.AbstractTimeConsumer;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * {@code AbstractResourceLoader} contains common implementation for a {@code ResourceLoader}.
 * 
 * <p>Extend {@code AbstractResourceLoader} to implement most methods required
 * for a {@code ResourceLoader}.
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.io.file.AbstractResourceLoader extends AbstractTimeConsumer implements ResourceLoader {
	
	/** TODO: Documentation !!! */
	public static var FILE_NOT_FOUND_ERROR:String = "File not found";
	
	/** Location for the resource request. */
	private var uri:String;
	
	/** Method to pass resource request parameters. */
	private var method:String = "POST";
	
	/** Parameters to be used for the resource request. */
	private var parameters:Map;
	
	private var dC:CompositeEventDistributorControl;
	
	private var callBack:Executable;
	
	/**
	 * Constructs a new {@code AbstractResourceLoader}
	 * 
	 * <p>Pass all arguments from the extended constructor by using super to 
	 * add the parameters to the instance.
	 */
	function AbstractResourceLoader(Void) {
		super();
		dC = distributorControl;
		dC.acceptListenerType(ResourceStartListener);
		dC.acceptListenerType(ResourceCompleteListener);
		dC.acceptListenerType(ResourceProgressListener);
		dC.acceptListenerType(ResourceErrorListener);
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
	
	/**
	 * 
	 * @param uri location of the resource to load
	 * @param parameters (optional) parameters for loading the resource
	 * @param method (optional) POST/GET as method for submitting the parameters,
	 *        default method used if {@code method} was not passed-in is POST.
	 * @param callBack (optional) {@link Executable} to be executed after the
	 *        the resource was loaded.
	 */
	public function load(uri:String, method:String, parameters:Map, callBack:Executable):Void {
		if (!uri) {
			throw new IllegalArgumentException("Url has to be set for starting the process.", this, arguments);
		}
		this.uri = uri;
		this.parameters = parameters;
		this.callBack = callBack;
		this.method = (method.toUpperCase() == "GET") ? "GET" : "POST";
	}

	public function getParameterSubmitMethod(Void):String {
		return method;
	}

	public function getParameters(Void):Map {
		return parameters;
	}

	public function getResource(Void):Resource {
		return null;
	}
	
	private function sendStartEvent(Void):Void {
		var startDistributor:ResourceStartListener
			= dC.getDistributor(ResourceStartListener);
		startDistributor.onResourceStart(this);
	}
	
	private function sendErrorEvent(code:String, error):Void {
		var errorDistributor:ResourceErrorListener
			= dC.getDistributor(ResourceErrorListener);
		errorDistributor.onResourceError(this, code, error);
	}
	
	private function sendCompleteEvent(Void):Void {
		var completeDistributor:ResourceCompleteListener
			= dC.getDistributor(ResourceCompleteListener);
		completeDistributor.onResourceComplete(this);
		callBack.execute(this);
	}
	
	private function sendProgressEvent(Void):Void {
		var completeDistributor:ResourceProgressListener
			= dC.getDistributor(ResourceProgressListener);
		completeDistributor.onResourceProgress(this);
	}
	
}