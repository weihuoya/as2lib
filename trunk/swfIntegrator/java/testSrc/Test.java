/*
 * Created on 01.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import org.as2lib.swfIntegrator.*;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class Test {
    public static void main(String[] args) throws IOException {
        SwfIntegrator i = new SwfIntegrator();
        try {
            i.setConfiguration("C:/Dokumente und Einstellungen/HeideggerMartin/Desktop/java/swfIntegrator/test/config.xml");
            System.out.println("\nHTML CODE: \n\n"+i.getMovie("test"));
        } catch (IllegalSettingsException e) {
            // TODO Auto-generated catch block
            System.out.println("Error: "+e.getMessage());
        }
    }
}
