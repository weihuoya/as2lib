import org.as2lib.io.file.TTextFile;
import org.as2lib.io.file.TextFileFactory;
import org.as2lib.io.file.SimpleTextFileFactory;
import org.as2lib.data.type.Byte;

class org.as2lib.io.file.TSimpleTextFile extends TTextFile {
	public function getTextFileFactory(Void):TextFileFactory {
		return new SimpleTextFileFactory();
	}	
	
	public function testSmallContent() {
		validateSmallContent(
			getTextFileFactory().createTextFile(
				smallContent, new Byte(0), "uri")
		);
	}
	
	public function testCompleteContent() {
		validateCompleteContent(
			getTextFileFactory().createTextFile(
				completeContent, new Byte(0), "uri")
		);
	}
	
	public function testURI() {
		assertNull("No URI should return null",
			getTextFileFactory().createTextFile("", null, null).getLocation());
		assertUndefined("Undefined URI should return undefined",
			getTextFileFactory().createTextFile("", null, undefined).getLocation());
		assertEquals("Empty URI should return empty",
			getTextFileFactory().createTextFile("", null, "").getLocation(), "");
		assertEquals("Any URI should return empty",
			getTextFileFactory().createTextFile("", null, "Martin").getLocation(), "Martin");
		assertEquals("HTTP Uri should be returns as is",
			getTextFileFactory().createTextFile("", null, "www.as2lib.org").getLocation(),
			"www.as2lib.org");
		assertEquals("HTTP Uri should be returns as is 2",
			getTextFileFactory().createTextFile("", null, "http://www.as2lib.org").getLocation(),
			"http://www.as2lib.org");
		assertEquals("HTTP Parameters should be returns as is",
			getTextFileFactory().createTextFile("", null, "http://me@www.as2lib.org?home=true").getLocation(),
			"http://me@www.as2lib.org?home=true");
	}
	
	public function testBytes() {
		assertNull("No Size should return null",
			getTextFileFactory().createTextFile("", null).getSize());
		assertUndefined("Undefined Size should return undefined",
			getTextFileFactory().createTextFile("", undefined).getSize());
		assertEquals("Size should match set size", 
			getTextFileFactory().createTextFile("", new Byte(13)).getSize(), new Byte(13));
	}
}