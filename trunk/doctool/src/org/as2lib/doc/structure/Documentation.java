/*
 * Created on 22.01.2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.as2lib.doc.structure;

import java.util.ArrayList;
import java.util.List;
import java.io.File;

import org.as2lib.doc.parser.Language;
import org.as2lib.doc.structure.lang.SimpleClassContent;


/**
 * @author main
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class Documentation {
	private String title;
	private TypeCache types;
	private PackageCache packages;
	private Language lang;
	private List ignoredFiles;
	private List log;
	
	public Documentation(String title) {
		this.title = title;
		log = new ArrayList();
		types = new TypeCache(this);
		packages = new PackageCache(this);
	}
	
	public SimpleClassContent getClass(String name) {
		return (SimpleClassContent)null;
	}
	
	public void addDirectory(File directory) {
		File[] files = directory.listFiles();
		for(int i=0; i<files.length; i++) {
			if(files[i].isDirectory()) {
				addDirectory(files[i]);
			} else {
				addFile(files[i]);
			}
		}
	}
	
	public void addFile(File file) {
		log.add(lang.parse(file, this));
		//System.out.println(lang.parse(file, this));
	}
	
	/**
	 * @return Returns the title.
	 */
	public String getTitle() {
		return title;
	}
	
	/**
	 * @param title The title to set.
	 */
	public void setTitle(String title) {
		this.title = title;
	}
	/**
	 * @return Returns the lang.
	 */
	public Language getLanguage() {
		return lang;
	}
	/**
	 * @param lang The lang to set.
	 */
	public void setLanguage(Language lang) {
		this.lang = lang;
	}
	/**
	 * @return Returns the types.
	 */
	public TypeCache getTypes() {
		return types;
	}
	/**
	 * @return Returns the packages.
	 */
	public PackageCache getPackages() {
		return packages;
	}
}
