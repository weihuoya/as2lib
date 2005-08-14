/*
 * Created on 13.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator.util;

import java.io.*;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class StreamGobbler extends Thread {
        InputStream is;
        String type;
        
        public StreamGobbler(InputStream is, String type)
        {
            this.is = is;
            this.type = type;
        }
        
        public static void start(InputStream is, String type)
        {
            new StreamGobbler(is, type).start();
        }
        
        public void run()
        {
            try
            {
                InputStreamReader isr = new InputStreamReader(is);
                BufferedReader br = new BufferedReader(isr);
                String line=null;
                while ( (line = br.readLine()) != null)
                    System.out.println(type + line);    
                } catch (IOException ioe)
                  {
                    ioe.printStackTrace();  
                  }
        }
}
