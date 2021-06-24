package com.dynamsoft;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Get
 */
public class Get extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Get() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String uploadedDir = getServletContext().getInitParameter("file-upload");
		String filename = request.getParameter("filename");
		File file = new File(uploadedDir + filename);
		System.out.println(uploadedDir);
		System.out.println(filename);
		if (file.exists()) {
			response.setContentType("application/octet-stream");
			request.setCharacterEncoding("utf-8");
			response.setCharacterEncoding("utf-8");
			response.setHeader("Content-disposition", "attachment;filename=\""+filename+"\"");
			response.setContentLength((int) file.length());
			BufferedInputStream bis = new BufferedInputStream(new FileInputStream(file.getAbsolutePath()));
	        BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());
	         
	        byte[] buffer = new byte[1024];
	        int length = 0;
	         
	        while((length = bis.read(buffer)) != -1){
	            bos.write(buffer, 0, length);
	        }
	        
	        if (bis != null) bis.close();
	        if (bos != null) bos.close();	
		}else {
			response.sendError(404, "The file does not exist");
		}
	}

}

