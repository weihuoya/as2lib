/*
 * Created on 13.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator.util;

import java.io.IOException;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class Execution {
    
    private String info;
    private String call;
    
    public static void exec(String info, String call) throws IOException {
        new Execution(info, call).start();
    }
    
    public Execution(String info, String call) {
        this.info = info;
        this.call = call;
    }
    
    public void start() throws IOException {
        System.out.println("\n"+info+"\n - execution: "+call);
    	Process p = Runtime.getRuntime().exec(call);
        StreamGobbler.start(p.getInputStream(), "  -> ");
        StreamGobbler.start(p.getErrorStream(), "  ! Error ! ");
        int execExit = -1;
    	try {
            execExit = p.waitFor();
            System.out.println(" - exited with code: "+execExit);
        } catch (InterruptedException e1) {
            e1.printStackTrace();
        }
    }
}
