/*
 * Created on 13.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator.util;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class SwfCreator {
    
    private static int[] rawFileContent;
    
    protected static int[] getRawFileContent() {
        if(rawFileContent == null) {
	        rawFileContent = new int[25];
	        rawFileContent[0] = 70;
	        rawFileContent[1] = 87;
	        rawFileContent[2] = 83;
	        rawFileContent[3] = 7;
	        rawFileContent[4] = 25;
	        rawFileContent[5] = 0;
	        rawFileContent[6] = 0;
	        rawFileContent[7] = 0;
	        rawFileContent[8] = 48;
	        rawFileContent[9] = 10;
	        rawFileContent[10] = 0;
	        rawFileContent[11] = 160;
	        rawFileContent[12] = 0;
	        rawFileContent[13] = 1;
	        rawFileContent[14] = 1;
	        rawFileContent[15] = 0;
	        rawFileContent[16] = 67;
	        rawFileContent[17] = 2;
	        rawFileContent[18] = 255;
	        rawFileContent[19] = 255;
	        rawFileContent[20] = 255;
	        rawFileContent[21] = 64;
	        rawFileContent[22] = 0;
	        rawFileContent[23] = 0;
	        rawFileContent[24] = 0;
        }
        return rawFileContent;
    }
    
    public static void create(String path) throws IOException {
        int[] content = getRawFileContent();
        File swfFile = new File(path);
        swfFile.createNewFile();
        FileWriter os = new FileWriter(swfFile);
        for(int i=0; i<content.length; i++) {
            os.write(content[i]);
        }
        os.flush();
    }
}
