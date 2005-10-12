import org.as2lib.test.unit.TestCase;
import org.as2lib.app.exec.Call;
import org.as2lib.app.exec.Executable;
import org.as2lib.io.file.SwfFileLoader;
import org.as2lib.io.file.FileNotLoadedException;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.type.Byte;
import org.as2lib.io.file.LoadErrorListener;
import org.as2lib.io.file.LoadCompleteListener;
import org.as2lib.io.file.LoadProgressListener;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.AbstractFileLoader;
import org.as2lib.io.file.FileLoaderProcess;
import org.as2lib.io.file.SwfFile;

/**
 * @author HeideggerMartin
 */
class org.as2lib.io.file.TSwfLoader extends TestCase
	implements LoadCompleteListener,
		LoadErrorListener,
		LoadProgressListener {
	
	private static var ROOT = "org/as2lib/io/file/";
	private static var INVALID_FILE = ROOT+"nonExistent.swf";
	private static var TEST_CONTENT = ROOT+"test.swf";
	
	private var progressExpected:Boolean  = false;
	private var fileNotFoundExpected:Call;
	private var fileNotFoundOccured:Boolean = false;
	private var loadCallBack:Executable;
	private var mc:MovieClip;
	private var swfLoader:SwfFileLoader;
	
	public function setUp() {
		mc = _root.createEmptyMovieClip("test", _root.getNextHighestDepth());
	}
	
	public function onLoadProgress(l:FileLoader):Void {
		if (!progressExpected) {
			fail("Unexpected .onProgress error occured");
		} else {
			assertSame("Passed SwfLoader in onSwfProgress should match SwfLoader that starts",
				l, swfLoader);
		}
	}
	
	public function onLoadError(l:FileLoader, errorCode:String, error):Boolean {
		if (errorCode == AbstractFileLoader.FILE_NOT_FOUND_ERROR) {
			if (!fileNotFoundExpected) {
				fail("Unexpected .onFileNotFound error for file '"+error+"' occured");
			} else {
				fileNotFoundExpected.execute(l, errorCode, error);
			}
		} else {
			fail("Unexpected error with errorCode '"+errorCode+"' occured");
		}
		return false;
	}
	
	public function onLoadComplete(resourceLoader:FileLoader):Void {
		if (fileNotFoundExpected != null) {
			fail(".onLoad occured but .onFileNotFound was expected");
		} else {
			if (!loadCallBack) {
				fail("Unexpected .onLoadEvent occured for mc '"+mc._url+"'");
			} else {
				loadCallBack.execute(mc);
			}
		}
	}
	
	/**
	 * Validates if a invalid file throws a exception.
	 */
	public function testInValidFileSource() {
		var fileLoader:SwfFileLoader = new SwfFileLoader(mc);
		fileLoader.addListener(this);
		
		var loaderProcess:FileLoaderProcess = new FileLoaderProcess(fileLoader);
		loaderProcess.setUri(INVALID_FILE);
		fileNotFoundExpected = new Call(this, invalidNotFound);
		
		startProcess(loaderProcess);
	}
	
	private function invalidNotFound(loader:FileLoader, errorCode, uri) {
		assertEquals("The URI that has not been found should match the uri that"
			+" should be loaded", uri, INVALID_FILE);
	}
	
	/**
	 * Validates if a valid file can be loaded proper.
	 */
	public function testValidFileSource() {
		
		swfLoader = new SwfFileLoader(mc);
		assertThrows("File should not be available before loading",
			FileNotLoadedException, swfLoader, swfLoader.getFile, []);
		swfLoader.addListener(this);
		
		loadCallBack = new Call(this, onValidLoadTest);
		
		var param:Map = new HashMap();
		param.put("test1", "funny");
		param.put("test2", "hunny");
		
		var fileLoaderProcess:FileLoaderProcess = new FileLoaderProcess(swfLoader);
		fileLoaderProcess.setUri(TEST_CONTENT, "POST", param);
		progressExpected = true;
		
		startProcess(fileLoaderProcess);
	}
	
	private function onValidLoadTest() {
		assertEquals("The file should be 100% loaded", (swfLoader.getPercentage()), 100);
		assertFalse("The file should not be started anymore", swfLoader.hasStarted());
		assertTrue("The file should be finished", swfLoader.hasFinished());
		assertSame("The resulted file should match the generated file", SwfFile(swfLoader.getFile()).getContainer(), mc);
		assertEquals("The resulting fileSize should be 66", swfLoader.getBytesLoaded(), new Byte(66));
		logger.info(swfLoader.getTransferRate().toString()+"/s transfer rate");
		logger.info(swfLoader.getDuration().toString()+" transfer time");
		for(var i:String in mc) {
			switch(i) {
				case "test1":
					assertEquals("Parameter 'test1' should be 'funny'", "funny", mc[i]);
					break;
				case "test2":
					assertEquals("Parameter 'test1' should be 'hunny'", "hunny", mc[i]);
					break;
				default:
					fail("Unexpected Parameter '"+i+"' set to "+mc[i]);
			}
		}
	}

}