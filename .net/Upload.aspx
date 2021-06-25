<%@ Page Language="C#" AutoEventWireup="false"%>

<%
    try
    {
        HttpFileCollection files = HttpContext.Current.Request.Files;
        Console.WriteLine(files.Count);
        Console.WriteLine("Hello!");
        HttpPostedFile uploadfile = files["RemoteFile"];
        uploadfile.SaveAs("D:\\uploaded\\" + uploadfile.FileName);
        Response.ContentType="application/json";
        Response.Write("{\"status\": \"success\",\"filename\": \"" + uploadfile.FileName + "\"}");
    }
    catch (Exception)
    {
        Response.StatusCode = 500;
    }
%>
