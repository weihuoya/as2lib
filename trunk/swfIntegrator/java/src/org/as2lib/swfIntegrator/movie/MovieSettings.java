/*
 * Created on 13.08.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.swfIntegrator.movie;

import java.util.List;

/**
 * @author HeideggerMartin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class MovieSettings {
    private int width;
    private int height;
    private String version;
    private String main;
    private String alignMode;
    private String scaleMode;
    private String quality;
    private String alternativeOutput;
    
    /**
     * @return Returns the quality.
     */
    public String getQuality() {
        return quality;
    }
    /**
     * @param quality The quality to set.
     */
    public void setQuality(String quality) {
        this.quality = quality;
    }
    private boolean menuActive;
    private boolean transparent;
    private String backgroundColor;
    private List requiredLibraries;
    /**
     * @return Returns the alignMode.
     */
    public String getAlignMode() {
        return alignMode;
    }
    /**
     * @param alignMode The alignMode to set.
     */
    public void setAlignMode(String alignMode) {
        this.alignMode = alignMode;
    }
    /**
     * @return Returns the scaleMode.
     */
    public String getScaleMode() {
        return scaleMode;
    }
    /**
     * @param scaleMode The scaleMode to set.
     */
    public void setScaleMode(String scaleMode) {
        this.scaleMode = scaleMode;
    }
    /**
     * @return Returns the backgroundColor.
     */
    public String getBackgroundColor() {
        return backgroundColor;
    }
    /**
     * @param backgroundColor The backgroundColor to set.
     */
    public void setBackgroundColor(String backgroundColor) {
        this.backgroundColor = backgroundColor;
    }
    /**
     * @return Returns the height.
     */
    public int getHeight() {
        return height;
    }
    /**
     * @param height The height to set.
     */
    public void setHeight(int height) {
        this.height = height;
    }
    /**
     * @return Returns the main.
     */
    public String getMain() {
        return main;
    }
    /**
     * @param main The main to set.
     */
    public void setMain(String main) {
        this.main = main;
    }
    /**
     * @return Returns the relatedLibraries.
     */
    public List getRequiredLibraries() {
        return requiredLibraries;
    }
    /**
     * @param relatedLibraries The relatedLibraries to set.
     */
    public void setRequiredLibraries(List requiredLibraries) {
        this.requiredLibraries = requiredLibraries;
    }
    /**
     * @return Returns the transparent.
     */
    public boolean isTransparent() {
        return transparent;
    }
    /**
     * @param transparent The transparent to set.
     */
    public void setTransparent(boolean transparent) {
        this.transparent = transparent;
    }
    /**
     * @return Returns the version.
     */
    public String getVersion() {
        return version;
    }
    /**
     * @param version The version to set.
     */
    public void setVersion(String version) {
        this.version = version;
    }
    /**
     * @return Returns the width.
     */
    public int getWidth() {
        return width;
    }
    /**
     * @param width The width to set.
     */
    public void setWidth(int width) {
        this.width = width;
    }
    /**
     * @return Returns the menuActive.
     */
    public boolean isMenuActive() {
        return menuActive;
    }
    /**
     * @param menuActive The menuActive to set.
     */
    public void setMenuActive(boolean menuActive) {
        this.menuActive = menuActive;
    }
    /**
     * @return Returns the alternativeOutput.
     */
    public String getAlternativeOutput() {
        return alternativeOutput;
    }
    /**
     * @param alternativeOutput The alternativeOutput to set.
     */
    public void setAlternativeOutput(String alternativeOutput) {
        this.alternativeOutput = alternativeOutput;
    }
}
