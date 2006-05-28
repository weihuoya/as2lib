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
 * @author Simon Wacker
 * @author Christophe Herreman
 */
public class UnitTest extends Task {
	
	private File swf;
	private File flashPlayer;
	private int port;
	
	public UnitTest() {
		port = 3212;
	}
	
	public void setSwf(File swf) {
		this.swf = swf;
	}
	
	public File getSwf() {
		return swf;
	}
	
	public void setFlashPlayer(File flashPlayer) {
		this.flashPlayer = flashPlayer;
	}
	
	public File getFlashPlayer() {
		return flashPlayer;
	}
	
	public void setPort(int port) {
		this.port = port;
	}
	
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
						if (element.getNodeName().equals("finish")) {
							if (element.getAttribute("hasErrors").equals("true")) {
								task.log(message, Project.MSG_ERR);
							}
							else {
								task.log(message);
							}
							task.log("-\n-");
							process.destroy();
							return;
						}
						else if (element.getNodeName().equals("error")) {
							task.log(message, Project.MSG_ERR);
						}
						else {
							task.log(message);
						}
					}
				}
				/*while (true) {
					Socket socket = server.accept();
					in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
					char[] charBuffer = new char[1];
					boolean receivedResult = false;
					while (in.read(charBuffer, 0, 1) != -1) {
						StringBuffer stringBuffer = new StringBuffer(8192);
						while (charBuffer[0] != '\0') {
							stringBuffer.append(charBuffer[0]);
							in.read(charBuffer, 0, 1);
						}
						if (!receivedResult) {
							receivedResult = true;
							task.log("-\n-");
						}
						task.log(stringBuffer.toString());
					}
					if (receivedResult) {
						task.log("-\n-");
						process.destroy();
						break;
					}
				}*/
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
			//task.log("Starting server...");
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
			//task.log("Stopping server...");
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
