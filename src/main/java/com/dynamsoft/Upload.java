package com.dynamsoft;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 * Servlet implementation class Upload
 */
public class Upload extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * Default constructor. 
     */
    public Upload() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String contentType = request.getContentType();
	    if (contentType.contains("multipart/form-data")) {
	        String uploadedDir = getServletContext().getInitParameter("file-upload");
	        Part filePart = request.getPart("RemoteFile");
	        String fileName = filePart.getSubmittedFileName();
	        File output = new File(uploadedDir + fileName);
	        System.out.println(uploadedDir + filePart.getSubmittedFileName());
	        OutputStream outStream = new FileOutputStream(output);
	        
	        InputStream in = filePart.getInputStream();
	        byte[] buffer = new byte[in.available()];
	        in.read(buffer, 0, in.available());
	        filePart.getInputStream().read(buffer);
	        outStream.write(buffer);
	        outStream.close();
	        response.setContentType("application/json");
	        response.getWriter().write("{\"status\": \"success\",\"filename\": \""+ fileName +"\"}");
	    } else {
	    	response.sendError(500, "Only multipart/form-data supported");
	    }
	}

}
