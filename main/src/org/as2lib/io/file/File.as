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
 
import org.as2lib.core.BasicInterface;
import org.as2lib.io.file.FileListener;

/**
 * Definition for a file with a loading delay.
 * Almost general definition for a file used in flash. It supports loading and response events.
 * 
 * Example:
 * <CODE>
 * import org.as2lib.io.file.FileListener;
 * import org.as2lib.io.file.SimpleFile; // Standard Implementation for a file.
 * 
 * class MyClass implements FileListener {
 *     public function MyClass() {
 *         var file:File = new SimpleFile(); // Choose your implementation.
 *         file.addListener(this); // Add the instance as listener.
 *         file.load("MyFile.txt"); // Load the source file.
 *     }
 * 
 *     public function onLoad(fileInfo:FileEventInfo):Void {
 *	       trace("I have loaded my file!");
 * 		   trace("Content of the file: "+fileInfo.getFile().getContent());
 * 	       trace("Content of line 2: "+fileInfo.getFile().getLine(1));
 *     }
 *       
 *     public function onProgress(fileInfo:FileEventInfo):Void {
 * 	       trace("I am loading my file: "+fileInfo.getFile().getBytesLoaded());
 *     }
 *       
 *     public function onFileNotFound(fileInfo:FileEventInfo):Void {
 *	       trace("I havn't found my file!");
 *     }
 * }
 * </CODE>
 * 
 * @author Martin Heidegger
 */
interface org.as2lib.io.file.File extends BasicInterface {
	
	/**
	 * Loads a file from a location.
	 * This method is similar to the MovieClip.load method.
	 * 
	 * @param location Location (URL) to of the file to load.
	 */
	public function load(location:String):Void;
	
	/**
	 * Boolean flag if the file is loaded.
	 * 
	 * @return true if the file is loaded. false if the file is loading or .load wasn't called.
	 */
	public function isLoaded(Void):Boolean;
	
	/**
	 * Boolean flag if the file is loading.
	 * 
	 * @return true if the file is loading. false if the file is already loaded or .load wasn't called.
	 */
	public function isLoading(Void):Boolean;
	
	/**
	 * Boolean flag if the file exists.
	 * Note: Flash has usually some kind of delay with this method that has to be recognized by its
	 *       implementation.
	 * 
	 * @throws org.as2lib.io.file.FileNotLoadedException If nothing has been loaded before.
	 * @return true if the file exists.
	 */
	public function exists(Void):Boolean;
	
	/**
	 * Getter for the content of the complete file.
	 * 
	 * @return Content of the file.
	 */
	public function getContent(Void):String;
	
	/**
	 * Getter for the content in the specific line of the content.
	 * It will return "undefined" if the line doesn't exist. The line will not
	 * contain the linebreak.
	 * 
	 * @param line Line to get the content of (starting with 0).
	 * @return Content of the line.
	 */
	public function getLine(line:Number):String;
	
	/**
	 * Returns the amount of lines in the content.
	 * 
	 * @return Amount of lines within the content.
	 */
	public function countLines(Void):Number;
	
	/**
	 * Location of the File.
	 * 
	 * @return The location of the file as loaded with load.
	 */
	public function getLocation(Void):String;
	
	/**
	 * Getter for the bytes that has been loaded already.
	 * It will return 0 if no bytes have been loaded.
	 * 
	 * @return Amount of bytes that has been loaded.
	 */
	public function getBytesLoaded(Void):Number;
	
	/**
	 * Getter for the total filesize in bytes.
	 * 
	 * @return Total size of the file in bytes.
	 */
	public function getBytesTotal(Void):Number;
	
	/**
	 * Adds a listener to the file for all events published by the file.
	 * 
	 * @param Listener for the file.
	 * @see FileListener
	 */
	public function addListener(listener:FileListener):Void;
}