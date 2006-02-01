import org.as2lib.test.unit.TestCase;
import org.as2lib.lang.NumberFormat;
import org.as2lib.data.holder.properties.SimpleProperties;

/**
 * 
 * @author Martin Heidegger
 */
class org.as2lib.lang.TNumberFormat extends TestCase {
	
	private var nF:NumberFormat;
	
	public function setUp() {
		nF = new NumberFormat();
	}
	
	public function testNormal() {
		
		// Normal tests
		assertEquals("123123112.1241412 formatted with Defaultformat should be *.## - round (not floor)", nF.format(123123112.1241412), "123123112.12");
		assertEquals("123123112.1251412 formatted with Defaultformat should be *.## - round (not ceil)", nF.format(123123112.1251412), "123123112.13");
		
		// Overloading tests
		assertEquals("12.123 Overloading of format does not work", nF.format(12.1234, "#.###"), "12.123");
		//assertEquals("12.13 Overloading of round does not work", nF.format(12.123, null, "ceil"), "12.13");
		//assertEquals("Overloading of comma doesnt work", nF.format(12.123, null, null, ","), "12,12");
		
		// More complex tests
		assertEquals("'#0.#' with 12 should result in '12'", nF.format(12,"#0.#"), "12");
		assertEquals("'#0.#0' with 12 should result in '12.0'", nF.format(12,"#0.#0"), "12.0");
		assertEquals("'#0.0#' with 12 should result in '12.0'", nF.format(12,"#0.0#"), "12.0");
		assertEquals("'00.#' with 2 should result in '02.'", nF.format(2,"00."), "02.");
		assertEquals("'0.' with 12.5 should result in '13.'", nF.format(12.5,"0."), "13.");
		assertEquals("'0.0' with 12 should result in '12.0'", nF.format(12,"0.0"), "12.0");
		assertEquals("'00000000.000000' with 12.4 should result in '00000012.400000'", nF.format(12.4,"00000000.000000"), "00000012.400000");
		assertEquals("'00000000.000000' with 12.4 should result in '00000012.400000'", nF.format(12.4,"00000000.000000"), "00000012.400000");
	}
	
	public function testMinus() {
		assertEquals("'0.0' with -1.2 should result in '-1.2'", nF.format(-1.2, "0.0"), "-1.2");
		assertEquals("'- 0.0 with -1.2 should result in '- 1.2'", nF.format(-1.2, "- 0.0"), "- 1.2");
		assertEquals("'- 0.0' with 1.2 should result in '+ 1.2'", nF.format(1.2, "- 0.0"), "+ 1.2"); 
		assertEquals("'0.0;- 0.0' with -1.2 should result in '- 1.2'", nF.format(-1.2, "0.0;- 0.0"), "- 1.2");
		assertEquals("'0.0;- 0.0' with 1.2 should result in '1.2'", nF.format(1.2, "0.0;- 0.0"), "1.2");
	}
	
	public function testMantisse() {
		assertEquals("'0E0' with 12 should result in '1E1'", nF.format(10,"0E0"), "1E1");
		assertEquals("'##0E0 %' with 12 should result in '1E3 %'", nF.format(10,"##0E0 %"), "1E3 %");
		assertEquals("'0.0E0' with 12 should result in '1.2E1'", nF.format(12,"0.0E0"), "1.2E1");
		assertEquals("'0.0E0' with 12 should result in '1.2E1'", nF.format(12,"0.0E0"), "1.2E1");
		assertEquals("'0.0E0.#' with 12 should result in '1.2E1'", nF.format(12,"0.0E0.#"), "1.2E1");
		assertEquals("'0.0E00.#' with 12 should result in '1.2E01'", nF.format(12,"0.0E00.#"), "1.2E01");
		assertEquals("'###0.0#####E0' with 0.000105 should result in '1E-4'", nF.format(0.000105,"###0.0#####E0"), "1.05E-5"); 
	}
	
	public function testWithText() {
		assertEquals("'\u00A4 #0.0' with 12 should result in '$ 12.'", nF.format(12,"\u00A4 #0.0"), "$ 12.0");
		assertEquals("'#0.0 m/s' with 12 should result in '12.0 m/s'", nF.format(12,"#0.0 m/s"), "12.0 m/s");  
	}
	
	public function testSeperator() {
		assertEquals("'#,###,##0.##' with 1 should result in '1'", nF.format(1, "#,###,##0.##"), "1");
		assertEquals("'#,###,##0.##' with 1234567 should result in '1,234,567'", nF.format(1234567, "#,###,##0.##"), "1,234,567");
		assertEquals("'#,###,##0.00' with 1234567 should result in '1,234,567.12'", nF.format(1234567.12, "#,###,##0.00"), "1,234,567.12");
		assertEquals("'#,###,##0' with 1234567,89 should result in '1,234,568'", nF.format(1234567.89, "#,###,##0"), "1,234,568");
	}
	
	public function testPercent() {
		assertEquals("'0.0%' with 0.25 should result in '25.0%'", nF.format(0.25, "0.0%"), "25.0%");
		assertEquals("'0.#%' with 0.25 should result in '25%'", nF.format(0.25, "0.#%"), "25%");
		assertEquals("'0.%' with 0.25 should result in '25.%'", nF.format(0.25, "0.%"), "25.%");
	}
	
	public function testComments() {
		assertEquals("pattern >'' 'dx0#.#' 00.0 '0.x0#'< with Math.PI should result in >' dx0#.# 314.2 0.x0#<", nF.format(Math.PI*100, "'' 'dx0#.#' 00.0 '0.x0#'"), "' dx0#.# 314.2 0.x0#");
		assertEquals("pattern >0'.##'.0< with 1 should result in >1.##.0<", nF.format(1, "0'.##'.0"), "1.##.0");
		assertEquals("pattern >0''.'0'0< with 1.35 should result in >1'.04<", nF.format(1.35, "0''.'0'0"), "1'.04");
		assertEquals("pattern >m/'.8s'0''.'0'0< with 1.35 should result in >1'.04<", nF.format(1.35, "m/'.8s'0''.'0'0"), "m/.8s1'.04");
	}
	
	public function testSpecialCases() {
		assertEquals("'0.0' with Infinity should result in 'Infinity'", nF.format(Infinity, "0.0"), "Infinity");
		assertEquals("'0.0%' with Infinity should result in 'Infinity%'", nF.format(Infinity, "0.0%"), "Infinity%");
		assertEquals("'0.0' with Math.PI should result in '3.1'", nF.format(Math.PI, "0.0"), "3.1");
	}
	
}
