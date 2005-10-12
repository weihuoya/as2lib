
import org.as2lib.io.file.TextFile;
import org.as2lib.io.file.TextFileLoader;
import org.as2lib.io.file.TextFileFactory;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.FileLoaderProcess;
import org.as2lib.io.file.LoadStartListener;
import org.as2lib.io.file.LoadCompleteListener;
import org.as2lib.io.file.LoadErrorListener;
import org.as2lib.io.file.LoadProgressListener;
import org.as2lib.io.file.AbstractFileLoader;
import org.as2lib.io.file.TTextFile;

/**
 *
 */
class org.as2lib.io.file.TTextFileLoader extends TTextFile implements
	LoadStartListener,
	LoadCompleteListener,
	LoadErrorListener,
	LoadProgressListener {
	
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	/** Holder for the File */
	private var file:TextFile;
	
	private static var PATH:String = "org/as2lib/io/file/";
	private static var NOT_EXISTING_FILE:String = PATH+"simpleFile.txt";
	private static var UNICODE_FILE:String = PATH+"simpleFile_Unicode.txt";
	private static var ASCII_FILE:String = PATH+"simpleFile_ASCII.txt";
	private static var MAC_LINEBREAKS_FILE:String = PATH+"simpleFile_MacBreaks.txt";
	private static var UNIX_LINEBREAKS_FILE:String = PATH+"simpleFile_UnixBreaks.txt";
	private static var WINDOWS_LINEBREAKS_FILE:String = PATH+"simpleFile_WinBreaks.txt";
	
	private var fileLoader:FileLoaderProcess;
	
	private function getFileFactory():TextFileFactory {
		return null;
	}
	
	private function getTextFileLoader():TextFileLoader {
		return new TextFileLoader(getFileFactory());
	}
	
	public function setUp(Void):Void {
		System.useCodepage = false;
		var fL:FileLoader = getTextFileLoader();
		fL.addListener(this);
		fileLoader = new FileLoaderProcess(fL);
	}
	
	public function testNotFound(Void):Void {
		fileLoader.setUri(NOT_EXISTING_FILE);
		startProcess(fileLoader);
	}
	
	public function testUnicode(Void):Void {
		fileLoader.setUri(UNICODE_FILE);
		startProcess(fileLoader);
	}
	public function testASCII(Void):Void {
		fileLoader.setUri(ASCII_FILE);
		startProcess(fileLoader);
	}
	public function testMacLineBreaks(Void):Void {
		fileLoader.setUri(MAC_LINEBREAKS_FILE);
		startProcess(fileLoader);
	}
	public function testUnixLineBreaks(Void):Void {
		fileLoader.setUri(UNIX_LINEBREAKS_FILE);
		startProcess(fileLoader);
	}
	public function testWindowsLineBreaks(Void):Void {
		fileLoader.setUri(WINDOWS_LINEBREAKS_FILE);
		startProcess(fileLoader);
	}
	public function onLoadComplete(resourceLoader:FileLoader):Void {
		if (resourceLoader instanceof FileLoader) {
			var file:TextFile = TextFile(resourceLoader.getFile());
			var location:String = file.getLocation();
			switch(location){
				case MAC_LINEBREAKS_FILE:
				case ASCII_FILE:
					validateSmallContent(file);
					validateFile(file);
					break;
				case UNICODE_FILE:
				case UNIX_LINEBREAKS_FILE:
				case WINDOWS_LINEBREAKS_FILE:
					validateCompleteContent(file);
					validateFile(file);
					break;
				case NOT_EXISTING_FILE:
					fail("Not existing file was loaded.");
					break;
				default:
					fail("Unexpected File found: "+location);
			}
		} else {
			fail ("Unexpected Resourceloader '"+resourceLoader+"' has completed");
		}
	}
	private function validateFile(file:TextFile):Void {
		validateLines(file);
		validateFileSize(file);
	}
	private function validateFileSize(file:TextFile):Void {
		assertNotEmpty("No valid total file size set in "+file.getLocation(), file.getSize());
		assertNotEmpty("No valid loaded file size set in "+file.getLocation(), file.getSize());
	}
	public function onLoadError(resourceLoader:FileLoader, errorCode:String, error):Boolean {
		if (errorCode == AbstractFileLoader.FILE_NOT_FOUND_ERROR) {
			if(error != NOT_EXISTING_FILE) {
				fail("File not found: "+error);
			}
		} else {
			fail("Unexpected Error: "+errorCode);
		}
		return false;
	}
	public function onLoadProgress(resourceLoader:FileLoader):Void {
		assertNotEmpty("Loaded Bytes in "+resourceLoader.getUri()+" may never be undefined", resourceLoader.getBytesLoaded());
		assertNotEmpty("Total Bytes in "+resourceLoader.getUri()+" may never be undefined", resourceLoader.getBytesTotal());
		assertTrue(resourceLoader.getUri()+" should be in loading state if the progress event was sent", fileLoader.isRunning());
	}
	
	public function tearDown(Void):Void {
		delete file;
	}
	
	public function onLoadStart(resourceLoader:FileLoader) : Void {
	}
}