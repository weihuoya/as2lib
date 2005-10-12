import org.as2lib.test.unit.TestCase;
import org.as2lib.io.file.TextFile;
import org.as2lib.data.type.MultilineString;
import org.as2lib.util.ObjectUtil;

/**
 * @author HeideggerMartin
 */
class org.as2lib.io.file.TTextFile extends TestCase {
	
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	private var smallContent:String = "Line1"
								+  "\nLine2"
								+  "\nLine3"
								+  "\nSpecial Chars: \\=)(&%a@"
								+  "\nDummy line";
								
	private var completeContent:String = "Line1"
							+  "\nLine2"
							+  "\nLine3"
							+  "\nSpecial Chars: äöü\\=)(&%a@µ"
							+  "\nJapanese Characters: 滾漲滯";
	
	private function validateLines(file:TextFile):Void {
		var content:MultilineString = new MultilineString(file.getContent());
		var lineCount = content.getLineCount();
		var i:Number;
		assertEquals("Incorrect Amount of lines found in "+file.getLocation(), lineCount, 5);
		for(i=0; i<lineCount; i++) {
			assertTypeOf("Line not found in "+file.getLocation(), content.getLine(i), ObjectUtil.TYPE_STRING);
		}
		assertUndefined("Index of line out of bounds in "+file.getLocation(), content.getLine(i));
	}
	
	private function validateSmallContent(file:TextFile):Void {
		var content = new MultilineString(file.getContent());
		assertEquals("Content is not correct in "+file.getLocation(), content, smallContent);
	}
	
	private function validateCompleteContent(file:TextFile):Void {
		var content:String = new MultilineString(file.getContent());
		assertEquals("Content is not correct in "+file.getLocation(), content, completeContent);
	}
}