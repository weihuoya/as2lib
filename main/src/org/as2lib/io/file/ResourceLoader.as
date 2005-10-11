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

import org.as2lib.data.type.Byte;
import org.as2lib.data.holder.Map;
import org.as2lib.data.type.Bit;
import org.as2lib.env.event.EventListenerSource;
import org.as2lib.app.exec.Executable;
import org.as2lib.io.file.Resource;
import org.as2lib.data.type.Time;

/**
 * {@code ResourceLoader} is a {@link Process} to handle the loading of a external
 * resource.
 * 
 * <p>A {@code ResourceLoader} allows to get a resource and create a representation
 * of the certain resource to allow proper access.
 * 
 * <p>It is build to handle the loading of one resource. But it can be executed 
 * twice or more often. This is because its possible to handle more than one
 * resource request parallel in any system.
 * 
 * <p>Example to handle the loading of a resource:
 * <code>
 *   import org.as2lib.io.file.ResourceLoader;
 *   import org.as2lib.io.file.ResourceListener;
 *   
 *   class Main implements ResourceListener {
 *   
 *     public function main(loader:ResourceLoader):Void {
 *       loader.setUri("test.txt");
 *       loader.start();
 *     }
 *     
 *     public function onResourceLoad(loader:ResourceLoader):Void {
 *       var resource = loader.getResource();
 *       // Do anything you like....
 *     }
 *     
 *     public function onResourceNotFound(uri:String):Void {
 *       trace("Resource could not be found"+uri);
 *     }
 *     
 *     public function onResourceProgress(loader:ResourceLoader):Void {
 *       trace("loaded: "+loader.getPercentage()+"% of "+loader.getUri());
 *     }
 *     
 *     public function onResourceStartLoading(loader:ResourceLoader):Void {
 *     	 trace("started loading: "+loader.getUri());
 *     }
 *   }
 * </code>
 * 
 * TODO: Remove Process restriction! Use Mediator!
 * TODO: .load(uri, method, params) !!
 * TODO: Are configuration methods necessary ? - no
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
interface org.as2lib.io.file.ResourceLoader extends EventListenerSource {
	
	public function load(uri:String, method:String, params:Map, callBack:Executable):Void;
	
	/**
	 * Returns for the location of the resource that was requested to load.
	 * 
	 * @return location of the resource to load
	 */
	public function getUri(Void):String;
	
	/**
	 * Sets the {@code method} to pass request parameters for request.
	 * 
	 * @return method to pass request parameters
	 */
	public function getParameterSubmitMethod(Void):String;
	
	/**
	 * Sets the {@code parameters} for the request to the resource.
	 * 
	 * <p>Returns {@code null} if no parameters has been set.
	 * 
	 * @return parameters to be passed with the resource request
	 */
	public function getParameters(Void):Map;
	
	/**
	 * Returns the loaded resource.
	 * 
	 * @return the loaded resource
	 * @throws org.as2lib.io.file.ResourceNotLoadedException if the resource has
	 *         not been loaded yet
	 */
	public function getResource(Void):Resource;
	
	/**
	 * Returns the percentage of the execution of {@code null} if its not evaluable.
	 * 
	 * @returns the percentage of the execution or {@code null} if its not evaluable
	 */
	public function getPercentage(Void):Number;
	
	/**
	 * Returns the total amount of bytes that has been loaded.
	 * 
	 * <p>Returns {@code null} if its not possible to get the loaded bytes.
	 * 
	 * @return amount of bytes that has been loaded
	 */
	public function getBytesLoaded(Void):Byte;
	
	/**
	 * Returns the total amount of bytes that will approximately be loaded.
	 * 
	 * <p>Returns {@code null} if its not possible to get the total amount of bytes.
	 * 
	 * @return amount of bytes to load
	 */
	public function getBytesTotal(Void):Byte;
	
	/**
	 * Returns the current transfer rate for the execution.
	 * 
	 * @return transfer rate in bit (per second)
	 */
	public function getTransferRate(Void):Bit;
	
	/**
	 * TODO: Documentation!!!
	 */
	public function getEstimatedRestTime(Void):Time;
	
	/**
	 * TODO: Documentation!!!
	 */
	public function getEstimatedTotalTime(Void):Time;
	
	/**
	 * TODO: Documentation!!!
	 */
	public function getDuration(Void):Time;
}