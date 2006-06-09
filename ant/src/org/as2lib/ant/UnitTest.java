/*
 * Copyright the original author or authors.
 *
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.as2lib.ant;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.taskdefs.Execute;
import org.apache.tools.ant.types.Commandline;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;

/**
 * {@code UnitTest} executes a unit test swf and writes the result to the console.
 *
 * <p>The unit test swf must send the result over the XML socket, with host "localhost"
 * and port 3212 by default or the one declared in the build file. The unit test swf
 * may register the {@code XmlSocketTestListener} at the test runner which sends the
 * test execution information properly formatted to this task.
 *
 * <p>The sent test execution information must be formatted as follows:
 * <ul>
 *   <li>&lt;start&gt;Start message.&lt;/start&gt;</li>
 *   <li>&lt;update&gt;Update message.&lt;/update&gt;</li>
 *   <li>&lt;pause&gt;Pause message.&lt;/pause&gt;</li>
 *   <li>&lt;resume&gt;Resume message.&lt;/resume&gt;
 *   <li>&lt;error&gt;Error message.&lt;/error&gt;</li>
 *   <li>&lt;failure&gt;Failure message.&lt;/failure&gt;</li>
 *   <li>&lt;finish hasErrors="false/true"&gt;Finish message.&lt;/finish&gt;</li>
 *   <li>&lt;message&gt;Arbitrary message.&lt;/message&gt;</li>
 * </ul>
 *
 * <p>As soon as the ant task receives the finish information it will close the opened
 * unit test swf and finish its execution.
 *
 * <p>This task can take the following arguments:
 * <ul>
 *   <li>
 *     {@link #setSwf(File) swf} (test swf file to execute and receive unit test
 *     results from)
 *   </li>
 *   <li>
 *     {@link #setFlashPlayer(File) flashplayer} (location of the flashplayer to
 *     execute the swf with)
 *   </li>
 *   <li>{@link #setPort(int) port} (port of the xml socket to listen to)</li>
 * </ul>
 *
 * <p>You must supply 'swf' and 'flashplayer'.
 *
 * @author Simon Wacker
 * @author Christophe Herreman
 */
public class UnitTest extends Task {

	public static final String START_ELEMENT = "start";
	public static final String UPDATE_ELEMENT = "update";
	public static final String PAUSE_ELEMENT = "pause";
	public static final String RESUME_ELEMENT = "resume";
	public static final String ERROR_ELEMENT = "error";
	public static final String FAILURE_ELEMENT = "failure";
	public static final String FINISH_ELEMENT = "finish";
	public static final String HAS_ERRORS_ATTRIBUTE = "hasErrors";
	public static final String TRUE_VALUE = "true";

	private File swf;
	private File flashPlayer;
	private int port;

	/**
	 * Constructs a new {@code UnitTest} instance, with the default port 3212.
	 */
	public UnitTest() {
		port = 3212;
	}

	/**
	 * Sets the swf file which executes the compiled unit tests and sends the result
	 * through the xml socket.
	 */
	public void setSwf(File swf) {
		this.swf = swf;
	}

	/**
	 * Returns the swf file which executes the compiled unit tests and sends the result
	 * through the xml socket.
	 */
	public File getSwf() {
		return swf;
	}

	/**
	 * Sets the flash player to run the unit test swf in.
	 */
	public void setFlashPlayer(File flashPlayer) {
		this.flashPlayer = flashPlayer;
	}

	/**
	 * Returns the flash player to run the unit test swf in.
	 */
	public File getFlashPlayer() {
		return flashPlayer;
	}

	/**
	 * Sets the port to listen for unit test results on. The default port is 3212.
	 */
	public void setPort(int port) {
		this.port = port;
	}

	/**
	 * Returns the port to listen for unit test results on. The default port is 3212.
	 */
	public int getPort() {
		return port;
	}

	/**
	 * Executes this task.
	 *
	 * @throws BuildException if swf or flash player is not specified
	 */
	public void execute() throws BuildException {
		if (swf == null) {
			throw new BuildException("A unit test swf must be supplied.", getLocation());
		}
		if (flashPlayer == null) {
			throw new BuildException("A flash player must be supplied.", getLocation());
		}
		Commandline command = new Commandline();
		command.setExecutable(flashPlayer.getPath());
		command.createArgument().setFile(swf);
		Receiver receiver = new Receiver(this);
		receiver.startServer(port);
		try {
			log(command.toString());
			Process process = Execute.launch(getProject(), command.getCommandline(), null, getProject().getBaseDir(), true);
			receiver.setProcess(process);
			process.waitFor();
		}
		catch (IOException e) {
			throw new BuildException("Error running unit tests.", e, getLocation());
		}
		catch (InterruptedException e) {
			throw new BuildException("Error running unit tests.", e, getLocation());
		}
		receiver.stopServer();
	}

	private static class Receiver extends Thread {

		private Task task;
		private ServerSocket server;
		private BufferedReader in;
		private Process process;

		public Receiver(Task task) {
			this.task = task;
		}

		public void setProcess(Process process) {
			this.process = process;
		}

		public void run() {
			try {
				task.log("-\n-");
				String previousNodeName = "";
				while (true) {
					Socket socket = server.accept();
					in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
					char[] charBuffer = new char[1];
					while (in.read(charBuffer, 0, 1) != -1) {
						StringBuffer stringBuffer = new StringBuffer(8192);
						while (charBuffer[0] != '\0') {
							stringBuffer.append(charBuffer[0]);
							in.read(charBuffer, 0, 1);
						}
						DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
						DocumentBuilder builder = factory.newDocumentBuilder();
						Document document = builder.parse(new ByteArrayInputStream(stringBuffer.toString().getBytes()));
						Element element = document.getDocumentElement();
						String message = element.getFirstChild().getNodeValue();
						String nodeName = element.getNodeName();
						if (nodeName.equals(START_ELEMENT)) {
							task.log(message + "\n-");
						}
						else if (nodeName.equals(UPDATE_ELEMENT)) {
							task.log(message);
						}
						else if (nodeName.equals(PAUSE_ELEMENT)) {
							task.log("-\n" + message);
						}
						else if (nodeName.equals(RESUME_ELEMENT)) {
							task.log(message + "\n-");
						}
						else if (nodeName.equals(ERROR_ELEMENT) || nodeName.equals(FAILURE_ELEMENT)) {
							task.log(message, Project.MSG_ERR);
						}
						else if (nodeName.equals(FINISH_ELEMENT)) {
							if (!previousNodeName.equals(START_ELEMENT) &&
									!previousNodeName.equals(RESUME_ELEMENT)) {
								task.log("-");
							}
							if (element.getAttribute(HAS_ERRORS_ATTRIBUTE).equals(TRUE_VALUE)) {
								task.log(message, Project.MSG_ERR);
							}
							else {
								task.log(message);
							}
							task.log("-\n-");
							process.destroy();
							return;
						}
						else {
							task.log(message);
						}
						previousNodeName = nodeName;
					}
				}
			}
			catch (IOException e) {
				throw new BuildException("Error on reading result.", e, task.getLocation());
			}
			catch (ParserConfigurationException e) {
				throw new BuildException("Error on reading result.", e, task.getLocation());
			}
			catch (SAXException e) {
				throw new BuildException("Error on reading result.", e, task.getLocation());
			}
		}

		public void startServer(int port) {
			try {
				server = new ServerSocket(port);
				super.start();
			}
			catch (IOException e) {
				stopServer();
				throw new BuildException("Error on starting server.", e, task.getLocation());
			}
		}

		public void stopServer() {
			try {
				if (server != null) {
					server.close();
				}
			}
			catch (IOException e) {
				throw new BuildException("Error on stopping server.", e, task.getLocation());
			}
			finally {
				try {
					if (in != null) {
						in.close();
					}
				}
				catch (IOException e) {
					throw new BuildException("Error on stopping server.", e, task.getLocation());
				}
			}
		}

	}

}
