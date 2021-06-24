<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>

<head>
    <title>Use Dynamic Web TWAIN to Upload</title>
    <script type="text/javascript" src="Resources/dynamsoft.webtwain.initiate.js"></script>
    <script type="text/javascript" src="Resources/dynamsoft.webtwain.config.js"></script>
</head>

<body>
    <select size="1" id="source" style="position: relative; width: 220px;"></select>
    <input type="button" value="Scan" onclick="AcquireImage();" />
    <input type="button" value="Load" onclick="LoadImage();" />
    <br />
    <label>
        <input type="radio" value="jpg" name="ImageType" id="imgTypejpeg" checked="checked" />JPEG</label>
    <label>
        <input type="radio" value="tif" name="ImageType" id="imgTypetiff" />TIFF</label>
    <label>
        <input type="radio" value="pdf" name="ImageType" id="imgTypepdf" />PDF</label>
    <input type="button" value="Upload" onclick="UploadImage();" />

    <!-- dwtcontrolContainer is the default div id for Dynamic Web TWAIN control.
    If you need to rename the id, you should also change the id in the dynamsoft.webtwain.config.js accordingly. -->
    <div id="dwtcontrolContainer"></div>
    <p><%
         out.println("Your IP address is " + request.getRemoteAddr());
      %></p>
    <div id="downloadContainer"></div>
    <script type="text/javascript">
        var console = window['console'] ? window['console'] : { 'log': function () { } };
        Dynamsoft.DWT.RegisterEvent('OnWebTwainReady', Dynamsoft_OnReady); // Register OnWebTwainReady event. This event fires as soon as Dynamic Web TWAIN is initialized and ready to be used

        var DWObject;

        function Dynamsoft_OnReady() {
            DWObject = Dynamsoft.DWT.GetWebTwain('dwtcontrolContainer'); // Get the Dynamic Web TWAIN object that is embeded in the div with id 'dwtcontrolContainer'
            if (DWObject) {
                var count = DWObject.SourceCount; // Populate how many sources are installed in the system
                for (var i = 0; i < count; i++)
                    document.getElementById("source").options.add(new Option(DWObject.GetSourceNameItems(i), i));  // Add the sources in a drop-down list
                document.getElementById("imgTypejpeg").checked = true;
            }
        }

        function AcquireImage() {
            if (DWObject) {
                var OnAcquireImageSuccess, OnAcquireImageFailure;
                OnAcquireImageSuccess = OnAcquireImageFailure = function () {
                    DWObject.CloseSource();
                };

                DWObject.SelectSourceByIndex(document.getElementById("source").selectedIndex);
                DWObject.OpenSource();
                DWObject.IfDisableSourceAfterAcquire = true;	// Scanner source will be disabled/closed automatically after the scan.
                DWObject.AcquireImage(OnAcquireImageSuccess, OnAcquireImageFailure);
            }
        }

        //Callback functions for async APIs
        function OnSuccess() {
            console.log('successful');
        }

        function OnFailure(errorCode, errorString) {
            alert(errorString);
        }

        function LoadImage() {
            if (DWObject) {
                DWObject.IfShowFileDialog = true; // Open the system's file dialog to load image
                DWObject.LoadImageEx("", Dynamsoft.DWT.EnumDWT_ImageType.IT_ALL, OnSuccess, OnFailure); // Load images in all supported formats (.bmp, .jpg, .tif, .png, .pdf). sFun or fFun will be called after the operation
            }
        }

        // OnHttpUploadSuccess and OnHttpUploadFailure are callback functions.
        // OnHttpUploadSuccess is the callback function for successful uploads while OnHttpUploadFailure is for failed ones.
        function OnEmptyResponse() {
            console.log('empty response');
        }

        function OnServerReturnedSomething(errorCode, errorString, sHttpResponse) {
        	console.log(sHttpResponse);
        	var response = JSON.parse(sHttpResponse);
        	if (response.status=="success"){
        		var downloadContainer = document.getElementById("downloadContainer");
        		downloadContainer.innerHTML="";
        		var link = document.createElement("a");
        		link.href = "./Get?filename="+response.filename;
        		link.innerText = "Download "+ response.filename;
        		link.target="_blank";
        		downloadContainer.append(link);
        	}else{
        		alert("Failed");
        	}
        }

        function UploadImage() {
            if (DWObject) {
                // If no image in buffer, return the function
                if (DWObject.HowManyImagesInBuffer == 0)
                    return;

                var strHTTPServer = location.hostname; //The name of the HTTP server. For example: "www.dynamsoft.com";
                var CurrentPathName = unescape(location.pathname);
                var CurrentPath = CurrentPathName.substring(0, CurrentPathName.lastIndexOf("/") + 1);
                var endPoint = CurrentPath + "Upload";
                console.log(endPoint);
                DWObject.IfSSL = false; // Set whether SSL is used
                DWObject.HTTPPort = location.port == "" ? 80 : location.port;

                var uploadfilename = getFormattedDate(); 

                // Upload the image(s) to the server asynchronously
                if (document.getElementById("imgTypejpeg").checked == true) {
                    //If the current image is B&W
                    //1 is B&W, 8 is Gray, 24 is RGB
                    if (DWObject.GetImageBitDepth(DWObject.CurrentImageIndexInBuffer) == 1)
                        //If so, convert the image to Gray
                        DWObject.ConvertToGrayScale(DWObject.CurrentImageIndexInBuffer);
                    //Upload image in JPEG
                    DWObject.HTTPUploadThroughPost(strHTTPServer, DWObject.CurrentImageIndexInBuffer, endPoint, uploadfilename + ".jpg", OnEmptyResponse, OnServerReturnedSomething);
                }
                else if (document.getElementById("imgTypetiff").checked == true) {
                    DWObject.HTTPUploadAllThroughPostAsMultiPageTIFF(strHTTPServer, endPoint, uploadfilename + ".tif", OnEmptyResponse, OnServerReturnedSomething);
                }
                else if (document.getElementById("imgTypepdf").checked == true) {
                    DWObject.HTTPUploadAllThroughPostAsPDF(strHTTPServer, endPoint, uploadfilename + ".pdf", OnEmptyResponse, OnServerReturnedSomething);
                }
            }
        }
        
        function getFormattedDate() {
            var date = new Date();

            var month = date.getMonth() + 1;
            var day = date.getDate();
            var hour = date.getHours();
            var min = date.getMinutes();
            var sec = date.getSeconds();

            month = (month < 10 ? "0" : "") + month;
            day = (day < 10 ? "0" : "") + day;
            hour = (hour < 10 ? "0" : "") + hour;
            min = (min < 10 ? "0" : "") + min;
            sec = (sec < 10 ? "0" : "") + sec;

            var str = date.getFullYear().toString() + month + day + hour + min + sec;

            return str;
        }
    </script>
</body>

</html>