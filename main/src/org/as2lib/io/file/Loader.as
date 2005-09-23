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
import org.as2lib.env.event.EventSupport;
import org.as2lib.env.overload.Overload;
import org.as2lib.io.file.CompositeFileFactory;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.FileFactory;
import org.as2lib.io.file.ResourceLoader;
import org.as2lib.io.file.ResourceListener;
import org.as2lib.io.file.SimpleFileFactory;
import org.as2lib.io.file.SwfLoader;
import org.as2lib.io.file.XmlFileFactory;
import org.as2lib.util.StringUtil;

/**
 * {@code Loader} is a central distributor for loading files.
 * 
 * <p>{@code Loader} should be used for loading files if you do not like to
 * bother about the certain loading mechianism.
 * 
 * <p>{@code Loader} is built as singleton. {@code Loader.getInstance} allows
 * access to the {@code Loader}.
 * 
 * <p>{@code Loader.getInstance().load("uri")} is available to load any common file.
 * 
 * <p>Loading a external {@code .swf} requires a {@code MovieClip} to load therefore
 * you should use {@code loadMovie} or use the overloaded {@code load} with passing
 * the {@code MovieClip} as second parameter.
 * 
 * <p>{@code Loader} uses paralell loading, this means it starts as much requests
 * as allowed paralell.
 * 
 * <p>{@code Loader} publishes events for {@link ResourceListener}.
 * 
 * <p>Example for using {@code Loader.load}:
 * <code>
 *   import org.as2lib.io.file.Loader;
 *   
 *   var loader:Loader = Loader.getInstance();
 *   loader.addListener(...); // Add your listener for the file loading.
 *   loader.load("content.txt"); 
 *   loader.load("content.xml");
 *   loader.load("content.swf", _root.createEmptyMovieClip("content", _root.getNextHighestDepth());
 * </code>
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.io.file.Loader extends EventSupport implements ResourceListener {
	
	/** Instance of the Loader. */
	private static var instance:Loader;
	
	/**
	 * Returns a {@code Loader} instance.
	 * 
	 * @return {@code Loader} instance.
	 */
	public static function getInstance():Loader {
		if (!instance) {
			instance = new Loader();
		}
		return instance;
	}	
	
	/** Factory to create {@code File} implementations, configurable. */
	private var fileFactory:FileFactory;
	
	/** Event to publish all events to {@link ResourceListener}. */
	private var rL:ResourceListener;
	
	/**
	 * Constructs a new {@code Loader}.
	 */
	private function Loader(Void) {
		distributorControl.acceptListenerType(ResourceListener);
		var factory:CompositeFileFactory = new CompositeFileFactory();
		factory.setFileFactoryByExtension("xml", new XmlFileFactory());
		fileFactory = factory;
		rL = distributorControl.getDistributor(ResourceListener);
	}
	
	/**
	 * Loads a {@code .swf} to a {@code MovieClip} instance.
	 * 
	 * @param uri location of the resource to load
	 * @param mc {@code MovieClip} as container for the {@code .swf} content
	 * @param parameters (optional) parameters for loading the resource
	 * @param method (optional) POST/GET as method for submitting the parameters,
	 *        default method used if {@code method} was not passed-in is POST.
	 * @return {@code SwfLoader} that loads the resource
	 */
	public function loadMovie(url:String, mc:MovieClip, parameters:Map,
			method:String):SwfLoader {
		var fL:SwfLoader = new SwfLoader(mc, url, parameters, method);
		fL.addListener(this);
		fL.start();
		return fL;
	}
	
	/**
	 * Loads a external file.
	 * 
	 * @param uri location of the resource to load
	 * @param parameters (optional) parameters for loading the resource
	 * @param method (optional) POST/GET as method for submitting the parameters,
	 *        default method used if {@code method} was not passed-in is POST.
	 */
	public function loadFile(url:String, parameters:Map, method:String):FileLoader {
		var fL:FileLoader = new FileLoader(fileFactory, url, parameters, method);
		fL.addListener(this);
		fL.start();
		return fL;
	}
	
	/**
	 * Defines the {@code FileFactory} to be used by {@code loadFile}.
	 * 
	 * <p>{@code loadFile} requires a {@code FileFactory} to generate the concrete
	 * {@code File} instance that represents the resource. This methods allows
	 * configuration of the supported file formats.
	 * 
	 * <p>The default configuration contains a {@link CompositeFileFactory} with
	 * {@link org.as2lib.io.file.SimpleFileFactory} as default {@code FileFactory}
	 * and {@link XmlFileFactory} for the extension "xml".
	 * 
	 * @param fileFactory {@code FileFactory} to be used by {@code loadFile}
	 */
	public function setFileFactory(fileFactory:FileFactory):Void {
		this.fileFactory = fileFactory;
	}
	
	/**
	 * @overload #loadMovie
	 * @overload #loadFile
	 */
	public function load(url, target) {
		var overload:Overload = new Overload();
		overload.addHandler([String, MovieClip, Map, String], loadMovie);
		overload.addHandler([String, MovieClip, Map], loadMovie);
		overload.addHandler([String, MovieClip], loadMovie);
		overload.addHandler([String, Map, String], loadFile);
		overload.addHandler([String, Map], loadFile);
		overload.addHandler([String], loadFile);
		return overload.forward(arguments);
	}
	
	/**
	 * (implementation detail) Handles the response of a finished {@code ResourceLoader}.
	 * 
	 * @param resourceLoader {@code ResourceLoader} that loaded the certain resource
	 */
	public function onResourceLoad(resourceLoader:ResourceLoader):Void {
		rL.onResourceLoad(resourceLoader);
	}

	/**
	 * (implementation detail) Handles the response if a {@code ResourceLoader}
	 * started working.
	 * 
	 * @param resourceLoader {@code ResourceLoader} that loaded the certain resource
	 */
	public function onResourceStartLoading(resourceLoader:ResourceLoader):Void {
		rL.onResourceStartLoading(resourceLoader);
	}

	/**
	 * (implementation detail) Handles the response if a {@code ResourceLoader}
	 * could not find a resource.
	 * 
	 * @param resourceLoader {@code ResourceLoader} that loaded the certain resource
	 */
	public function onResourceNotFound(uri:String):Void {
		rL.onResourceNotFound(uri);
	}

	/**
	 * (implementation detail) Handles the response if a {@code ResourceLoader}
	 * progressed loading.
	 * 
	 * @param resourceLoader {@code ResourceLoader} that loaded the certain resource
	 */
	public function onResourceProgress(resourceLoader:ResourceLoader):Void {
		rL.onResourceProgress(resourceLoader);
	}
}