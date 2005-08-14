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
public class DefaultHtmlGenerator implements HtmlGenerator {

    private Settings settings;
    private int id = 0;
    
    /* (non-Javadoc)
     * @see org.as2lib.swfIntegrator.html.HtmlGenerator#setSettings(org.as2lib.swfIntegrator.Settings)
     */
    public void setSettings(Settings settings) {
        // TODO Auto-generated method stub
        this.settings = settings;
    }

    /* (non-Javadoc)
     * @see org.as2lib.swfIntegrator.html.HtmlGenerator#createSwfCode(org.as2lib.swfIntegrator.movie.MovieSettings)
     */
    public String createSwfCode(MovieSettings movieSettings) {
        StringBuffer sB = new StringBuffer();
        sB.append("<script language=\"javascript\" type=\"text/javascript\"><!--");
        sB.append("as2lib_p=false;");
        sB.append("if((navigator.mimeTypes && navigator.mimeTypes[\"application/x-shockwave-flash\"])?navigator.mimeTypes[\"application/x-shockwave-flash\"].enabledPlugin:0){");
        sB.append    ("if(!as2lib_pV){");
        sB.append        ("w=navigator.plugins[\"Shockwave Flash\"].description.split(\" \");");
        sB.append        ("for(var i=0;i<w.length;++i){");
        sB.append            ("if(isNaN(parseInt(w[i]))){continue};");
        sB.append            ("var as2lib_pV=w[i];");
        sB.append        ("}");
        sB.append    ("}");  
        sB.append    ("as2lib_p=as2lib_pV>=");
        sB.append        (movieSettings.getVersion().toString());
        sB.append    (";");
        sB.append("}else if(navigator.userAgent&&navigator.userAgent.indexOf(\"MSIE\")>=0&&(navigator.appVersion.indexOf(\"Win\")!=-1)){");
        sB.append    ("document.write('<SC'+'RIPT LANGUAGE=VBScript\\>\\n");
        sB.append    ("on error resume next \\n");
        sB.append    ("as2lib_p=(IsObject(CreateObject(\"ShockwaveFlash.ShockwaveFlash.\"&");
        sB.append        (movieSettings.getVersion().toString());
        sB.append    ("))))\\n");
        sB.append    ("</SC'+'RIPT\\>\\n');");
        sB.append("}");
        sB.append("if(as2lib_p){");
        createProperOutput(movieSettings, sB);
        sB.append("}else{");
        createMissingOutput(movieSettings, sB);
        sB.append("}");
        sB.append("--></script>");
        return sB.toString();
    }
    
    private void createProperOutput(MovieSettings movieSettings, StringBuffer sB) {
        Integer id = new Integer(this.id++);
        sB.append("document.write('");
	        sB.append("<object classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" codebase=\"http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0\" width=\"");
	        sB.append(movieSettings.getWidth());
	        sB.append("\" height=");
	        sB.append(movieSettings.getHeight());
	        sB.append("\" id=\"as2lib_s");
	        sB.append(id);
	        sB.append("\" align=\"");
	        sB.append(movieSettings.getAlignMode());
	        sB.append("\"><param name=movie value=\"");
	        	sB.append(settings.getWebRoot());
	        	sB.append("/");
	        	sB.append(settings.getApplicationSwfTarget());
	        	sB.append("/");
	        	sB.append(movieSettings.getMain());
	        	sB.append(".swf\">");
	        sB.append("<param name=menu value=");
	        sB.append(movieSettings.isMenuActive());
	        sB.append("><param name=quality value=");
	        sB.append(movieSettings.getQuality());
	        sB.append("><param name=scale value=");
	        sB.append(movieSettings.getScaleMode());
	        sB.append("><param name=bgcolor value=");
	        sB.append(movieSettings.getBackgroundColor());
	        sB.append("><embed src=\"");
	            sB.append(settings.getWebRoot());
		    	sB.append("/");
		      	sB.append(settings.getApplicationSwfTarget());
		    	sB.append("/org_as2lib_swfIntegrator.swf");
	            sB.append(settings.getWebRoot());
		    	sB.append("/");
		      	sB.append(settings.getApplicationSwfTarget());
		    	sB.append("/");
		    	sB.append(movieSettings.getMain());
		    	sB.append(".swf\">");
		    sB.append(" menu=");
		    sB.append(movieSettings.isMenuActive());
		    sB.append(" quality=");
		    sB.append(movieSettings.getQuality());
		    sB.append(" scale=");
		    sB.append(movieSettings.getScaleMode());
		    sB.append(" bgcolor=");
		    sB.append(movieSettings.getBackgroundColor());
		    sB.append(" width=\"");
		    sB.append(movieSettings.getWidth());
		    sB.append("\" height=\"");
		    sB.append(movieSettings.getHeight());
		    sB.append("\" name=\"as2lib_s");
		    sB.append(id);
		    sB.append("\" align=\"");
		    sB.append(movieSettings.getAlignMode());
		    sB.append("\" type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\"></embed>");
		    sB.append("</object>");
	    sB.append("');");
    }
    
    private void createMissingOutput(MovieSettings movieSettings, StringBuffer sB) {
    }

}
