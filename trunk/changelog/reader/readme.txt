Release Information:

 This is the first release of the as2lib changelog reader - 0.9.
 It is available as evaluation version and as as2lib useage example.

 It reads a xml file that is valid as as2lib-changelog. The changelog
 format is defined as xml schema at:
   http://www.as2lib.org/changelog.xsd
   or http://as2lib.sourceforge.net/changelog.xsd

 The file "changelog.xml" contains an example changelog.

 By default the reader takes the relative path "changelog.xml" to read
 the file.

 You can change the xml file by setting the parameter "file"
 (in "FlashVars" or as parameter to the application url) to the changelog URL
 if you want.

 You can change the default xml file by changing the init action within
 the first frame of the changelog.fla (contained within the source)
 and recompile the source.


Known Bugs:

 * It is currently not sorted (simple one after another).
 * A "\n" adds two lines.
 * Horizontal scrollbars appears by very low width (sometimes).