import org.as2lib.test.unit.TestCase;
import org.as2lib.io.file.File;
import org.as2lib.io.file.FileEventInfo;
import org.as2lib.io.file.SimpleFile;
import org.as2lib.io.file.FileListener;
import org.as2lib.io.file.FileNotLoadedException;
import org.as2lib.util.ObjectUtil;

/**
 *
 */
class test.unit.org.as2lib.io.file.TFile extends TestCase implements FileListener {
	
	/** Holder for the File */
	private var file:File;
	
	private static var PATH:String = "org/as2lib/io/file/";
	private static var NOT_EXISTING_FILE:String = PATH+"simpleFile.txt";
	private static var UNICODE_FILE:String = PATH+"simpleFile_Unicode.txt";
	private static var ASCII_FILE:String = PATH+"simpleFile_ASCII.txt";
	private static var MAC_LINEBREAKS_FILE:String = PATH+"simpleFile_MacBreaks.txt";
	private static var UNIX_LINEBREAKS_FILE:String = PATH+"simpleFile_UnixBreaks.txt";
	private static var WINDOWS_LINEBREAKS_FILE:String = PATH+"simpleFile_WinBreaks.txt";
	
	public function setUp(Void):Void {
		System.useCodepage = false;
		file = new SimpleFile();
		file.addListener(this);
		assertFalse("File cannot be loading if you didn't call the action 'load': "+file.getLocation(), file.isLoading());
		assertThrows("File should throw a exception if you call exists while it isn't possible to load it: "+file.getLocation(), FileNotLoadedException, file, "exists", []);
	}
	public function testNotFound(Void):Void {
		file.load(NOT_EXISTING_FILE);
		assertThrows("File may not exist by simple loading it", FileNotLoadedException, file, "exists", []);
		pause();
	}
	
	public function testUnicode(Void):Void {
		file.load(UNICODE_FILE);
		validateLoadState(file);
		pause();
	}
	public function testASCII(Void):Void {
		file.load(ASCII_FILE);
		validateLoadState(file);
		pause();
	}
	public function testMacLineBreaks(Void):Void {
		file.load(MAC_LINEBREAKS_FILE);
		validateLoadState(file);
		pause();
	}
	public function testUnixLineBreaks(Void):Void {
		file.load(UNIX_LINEBREAKS_FILE);
		validateLoadState(file);
		pause();
	}
	public function testWindowsLineBreaks(Void):Void {
		file.load(WINDOWS_LINEBREAKS_FILE);
		pause();
	}
	private function validateLoadState(file:File):Void {
		assertThrows("File may not exist by simple loading it: "+file.getLocation(), FileNotLoadedException, file, "exists", []);
		assertTrue("File should be in 'loading' state by loading it: "+file.getLocation(), file.isLoading());
		assertFalse("File may not be loaded by simple loading it: "+file.getLocation(), file.isLoaded());
	}
	public function onLoad(fileInfo:FileEventInfo):Void {
		var file:File = fileInfo.getFile()
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
		assertTrue(file.getLocation()+" was loaded so the loaded state has to be true", file.isLoaded());
		assertFalse(file.getLocation()+" was loaded so it isn't loading anymore", file.isLoading());
		resume();
	}
	private function validateFile(file:File):Void {
		validateLines(file);
		validateFileSize(file);
		assertTrue("File .exists should return true because '"+file.getLocation()+"' was loaded properly", file.exists());
	}
	private function validateLines(file:File):Void {
		var content = file.getContent();
		var lineCount = file.countLines();
		assertEquals("Incorrect Amount of lines found in "+file.getLocation(), lineCount, 5);
		for(var i=0; i<lineCount; i++) {
			assertTypeOf("Line not found in "+file.getLocation(), file.getLine(i), ObjectUtil.TYPE_STRING);
		}
		assertUndefined("Index of line out of bounds in "+file.getLocation(), file.getLine(i));
	}
	private function validateSmallContent(file:File):Void {
		var content = file.getContent();
		assertEquals("Content is not correct in "+file.getLocation(), content, "Line1"
																			+  "\nLine2"
																			+  "\nLine3"
																			+  "\nSpecial Chars: \\=)(&%a@"
																			+  "\nDummy line");
	}
	private function validateCompleteContent(file:File):Void {
		var content = file.getContent();
		assertEquals("Content is not correct in "+file.getLocation(), content, "Line1"
																			+  "\nLine2"
																			+  "\nLine3"
																			+  "\nSpecial Chars: äöü\\=)(&%a@µ"
																			+  "\nJapanese Characters: 滾漲滯");
	}
	private function validateFileSize(file:File):Void {
		assertNotEmpty("No valid total file size set in "+file.getLocation(), file.getBytesTotal());
		assertNotEmpty("No valid loaded file size set in "+file.getLocation(), file.getBytesLoaded());
		
		assertEquals("Total file size does not match loaded filesize in loaded state in "+file.getLocation(), file.getBytesLoaded(), file.getBytesTotal());
	}
	public function onFileNotFound(fileInfo:FileEventInfo):Void {
		if(fileInfo.getFile().getLocation() != NOT_EXISTING_FILE) {
			fail("File not found: "+fileInfo.getFile().getLocation());
		}
		resume();
	}
	public function onProgress(fileInfo:FileEventInfo):Void {
		var file:File = fileInfo.getFile();
		assertNotEmpty("Loaded Bytes in "+file.getLocation()+" may never be undefined", file.getBytesLoaded());
		assertNotEmpty("Total Bytes in "+file.getLocation()+" may never be undefined", file.getBytesTotal());
		assertFalse(file.getLocation()+" cant be finished while progress event was sent", file.isLoaded());
		assertTrue(file.getLocation()+" should be in loading state if the progress event was sent", file.isLoading());
		assertTrue(file.getLocation()+" sended a progress event, so it mus exist!", file.exists())
	}
	public function tearDown(Void):Void {
		delete file;
	}
}