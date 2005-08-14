/*
 * Created on 14.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator.html;

import org.as2lib.swfIntegrator.Settings;
import org.as2lib.swfIntegrator.movie.MovieSettings;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public interface HtmlGenerator {
    public void setSettings(Settings settings);
    public String createSwfCode(MovieSettings movieSettings);
}
