<?php
/** WordPress's config file **/
/** http://wordpress.org/   **/

// ** MySQL settings ** //
define('DB_NAME', 'as2lib');     // The name of the database
define('DB_USER', 'as2lib');     // Your MySQL username
define('DB_PASSWORD', 'sonito03'); // ...and password
define('DB_HOST', 'mysql.sourceforge.net');     // 99% chance you won't need to change this value

// Change the prefix if you want to have multiple blogs in a single database.

$table_prefix  = 'wp_';   // example: 'wp_' or 'b2' or 'mylogin_'

/* Stop editing */

$server = DB_HOST;
$loginsql = DB_USER;
$passsql = DB_PASSWORD;
$base = DB_NAME;

define('ABSPATH', dirname(__FILE__).'/');

// Get everything else
require_once(ABSPATH.'wp-settings.php');
?>