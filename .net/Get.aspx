<%@ Page Language="C#" AutoEventWireup="false" %>
<%@ Import Namespace="System.IO" %>
<%
    String filename = Request.QueryString.Get("filename");
    if (File.Exists("D:\\uploaded\\" + filename))
    {
        Response.ContentType="application/octet-stream";
        FileStream fileStream = new FileStream("D:\\uploaded\\" + filename, FileMode.Open);
        Response.AppendHeader("content-length", fileStream.Length.ToString());
        Response.AppendHeader("content-disposition", string.Format("attachment; filename={0}", filename));
        byte[] buffer = new byte[fileStream.Length];
        fileStream.Read(buffer, 0, buffer.Length);
        Response.OutputStream.Write(buffer, 0, buffer.Length);
        Response.Flush();
        Response.Close();
    }
    else
    {
        Response.StatusCode = 404;
    }
%>

