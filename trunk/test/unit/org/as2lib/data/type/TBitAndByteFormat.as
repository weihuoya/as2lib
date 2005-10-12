import org.as2lib.test.unit.TestCase;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.data.type.Byte;
import org.as2lib.data.type.Bit;

class org.as2lib.data.type.TBitAndByteFormat extends TestCase {
	private var byteFormat:Byte;
	private var bitFormat:Bit;
	
	public function setUp(Void):Void {
		byteFormat = new Byte(1234);
		bitFormat = new Bit(1234*8);
	}
	public function testIllegalFloatingPoints(Void):Void {
		assertThrows(".setFloatingPoints has to throw a IllegalArgumentException if -1 is used", IllegalArgumentException, byteFormat, "setFloatingPoints", [-1]);
		assertThrows(".setFloatingPoints has to throw a IllegalArgumentException if null is used", IllegalArgumentException, byteFormat, "setFloatingPoints", [null]);
	}
	public function testSpecialFloatingPoints(Void):Void {
		byteFormat.setFloatingPoints(2);
		assertEquals("testing .getBit method using 2 comma positions", byteFormat.getBit(), 9872);
		assertEquals("testing .getBytes method using 2 comma positions", byteFormat.getBytes(), 1234);
		assertEquals("testing .getKiloBit method using 2 comma positions", byteFormat.getKiloBit(), 9.64);
		assertEquals("testing .getKiloBytes method using 2 comma positions", byteFormat.getKiloBytes(), 1.21);
		assertEquals("testing .getMegaBit method using 2 comma positions", byteFormat.getMegaBit(), 0.01);
		assertEquals("testing .getMegaBytes method using 2 comma positions", byteFormat.getMegaBytes(), 0);
		assertEquals("testing .getGigaBit method using 2 comma positions", byteFormat.getGigaBit(), 0);
		assertEquals("testing .getGigaBytes method using 2 comma positions", byteFormat.getGigaBytes(), 0);
		assertEquals("testing .getTeraBit method using 2 comma positions", byteFormat.getTeraBit(), 0);
		assertEquals("testing .getTeraBytes method using 2 comma positions", byteFormat.getTeraBytes(), 0);
		byteFormat.setFloatingPoints(3);
		assertEquals(".toString with using Bytes and using 3 comma positions", byteFormat.toString(), "1.205KB");
		assertEquals("testing .getKiloBit method using 3 comma positions", byteFormat.getKiloBit(), 9.641);
		assertEquals("testing .getKiloBytes method using 3 comma positions", byteFormat.getKiloBytes(), 1.205);
		byteFormat.setFloatingPoints(5);
		assertEquals("testing .getMegaBit method using 5 comma positions", byteFormat.getMegaBit(), 0.00941);
		assertEquals("testing .getMegaBytes method using 5 comma positions", byteFormat.getMegaBytes(), 0.00118);
	}
	
	public function testDefaultComma(Void):Void {
		assertEquals(".toString with using Bits", bitFormat.toString(), "9.64Kb");
		assertEquals(".toString with using Bytes", byteFormat.toString(), "1.21KB");
		
		assertEquals("testing .getBit method", byteFormat.getBit(), 9872);
		assertEquals("testing .getBytes method", byteFormat.getBytes(), 1234);
		assertEquals("testing .getKiloBit method", byteFormat.getKiloBit(), 9.64);
		assertEquals("testing .getKiloBytes method", byteFormat.getKiloBytes(), 1.21);
		assertEquals("testing .getMegaBit method", byteFormat.getMegaBit(), 0.01);
		assertEquals("testing .getGigaBit method", byteFormat.getGigaBit(), 0);
		assertEquals("testing .getGigaBytes method", byteFormat.getGigaBytes(), 0);
		assertEquals("testing .getTeraBit method", byteFormat.getTeraBit(), 0);
		assertEquals("testing .getTeraBytes method", byteFormat.getTeraBytes(), 0);
	}
	
	public function tearDown(Void):Void {
		delete bitFormat;
		delete byteFormat;
	}
}