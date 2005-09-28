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
import org.as2lib.data.type.Byte;
import org.as2lib.data.type.MultilineString;
import org.as2lib.io.file.File;
import org.as2lib.io.file.FileFactory;
import org.as2lib.io.file.SimpleFileFactory;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;

/**
 * {@code CompositeFileFactory} uses different {@code FileFactory} implementations
 * depending to the extension of the passed-in {@code uri} in {@code FileFactory.createFile}.
 * 
 * <p>Its a common case that different file extensions are used for different
 * kinds of file formats. {@code CompositeFileFactory} allows different processing
 * of resources depending to the extension of the loaded file.
 * 
 * <p>If a certain extension has not been specially set
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.io.file.CompositeFileFactory extends BasicClass implements FileFactory {

	/** {@code FileFactory} to be used if no other {@code FileFactory is available. */
    private var defaultFileFactory:FileFactory;
    
    /** */
    private var extensionFactories:Map;
    
    /**
     * Constructs a new {@code CompositeFileFactory}.
     */
    public function CompositeFileFactory(Void) {
    	defaultFileFactory = new SimpleFileFactory();
    	extensionFactories = new HashMap();
    }

	/**
	 * Creates a {@code File} implementation depending to the set {@code FileFactory}s.
	 * 
	 * @param source content of the {@code File} to create
	 * @param size size in {@link Byte} of the loaded resource
	 * @param uri location of the loaded resource
	 * @return {@code File} that represents the resource
	 */
	public function createFile(source:String, size:Byte, uri:String):File {
		var factory:FileFactory = extensionFactories.get(uri.substr(uri.lastIndexOf(".")));
		if (!factory) {
			factory = defaultFileFactory;
		}
		return factory.createFile(source, size, uri);
	}
	
	/**
	 * Sets the default {@code FileFactory} to be used in default case.
	 * 
	 * <p>If no other set {@code FileFactory} applies to the requested {@code uri}
	 * the passed-in {@code fileFactory} will be used.
	 * 
	 * @param fileFactory {@code FileFactory} to be used in default case
	 */
	public function setDefaultFileFactory(fileFactory:FileFactory):Void {
		defaultFileFactory = fileFactory;
	}
	
	/**
	 * Sets a certain {@code FileFactory} to be used for files with the passed-in
	 * {@code extension}.
	 * 
	 * <p>The passed-in extension should not contain a leading ".".
	 * 
	 * <p>Proper example:
	 * <code>
	 *   var compositeFileFactory:CompositeFileFactory = new CompositeFileFactory();
	 *   compositeFileFactory.setFileFactoryByExtension("txt", new SimpleFileFactory());
	 * </code>
	 * 
	 * @param extension extension of the file that should be recognized by the
	 * 		  passed-in {@code fileFactory}
	 * @param fileFactory {@code FileFactory} that creates the files
	 */
	public function setFileFactoryByExtension(extension:String,
			fileFactory:FileFactory):Void {
		extensionFactories.put(extension, fileFactory);
	}
	
	/**
	 * Sets a certain {@code FileFactory} to be used for files with one extension
	 * of the passed-in {@code extensions}.
	 * 
	 * <p>any of the passed-in extension should not contain a leading ".".
	 * 
	 * <p>Proper example:
	 * <code>
	 *   var compositeFileFactory:CompositeFileFactory = new CompositeFileFactory();
	 *   compositeFileFactory.setFileFactoryByExtensions(["txt", "prop"],
	 *   	new SimpleFileFactory());
	 * </code>
	 * 
	 * @param extensions list of extensions of files that should be recognized
	 *        by the passed-in {@code fileFactory}
	 * @param fileFactory {@code FileFactory} that creates the files
	 */
	public function setFileFactoryByExtensions(extensions:Array,
			fileFactory:FileFactory):Void {
		var i:Number;
		for( i=0; i<extensions.length; i++) {
			setFileFactoryByExtension(extensions[i], fileFactory);
		}
	}
}