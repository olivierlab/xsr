namespace XSR_HTML {
	const std::string header = "<!DOCTYPE html>\
<html>\n\
	<head>\n\
		<title>Steps Recording</title>\n\
		<link href=\"https://fonts.googleapis.com/css?family=Ubuntu\" rel=\"stylesheet\">\n\
		<style>@font-face{font-family:'Ubuntu';font-style:normal;font-weight:400;src:local('Ubuntu Regular'),local('Ubuntu-Regular'),url(https://fonts.gstatic.com/s/ubuntu/v10/sDGTilo5QRsfWu6Yc11AXg.woff2) format('woff2');unicode-range:U+0000-00FF,U+0131,U+0152-0153,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2212,U+2215;}body>div.title{font-family:\"Ubuntu\",sans-serif;font-size:2em;text-align:center;border-bottom-style:solid;border-width:thin;margin-bottom:10px;}div.instruction{margin:10px auto;padding:10px;max-width:80%;border:thin solid lightgray;border-radius:10px;display:table;}div.instruction div.title{font-family:monospace;font-size:1.2em;text-align:center;}div.footer{padding:5px;text-align:center;background-color:#f7f7f7;}img{margin-top:15px;display:block;width:100%}kbd{display:inline-block;margin:0 .1em;padding:.3em .4em;font-family:Ubuntu,Arial,\"libra sans\",sans-serif;font-size:75%;line-height:inherit;color:#242729;text-shadow:0 1px 0 #FFF;background-color:#e1e3e5;border:1px solid #adb3b9;border-radius:3px;box-shadow:0 1px 0 rgba(12,13,14,0.2),0 0 0 2px #FFF inset;white-space:nowrap;}apptitle{font-style:italic;}</style>\n\
		<meta charset=\"UTF-8\" />\n\
	</head>\n\
	<body>";
	const std::string title() {
		return "<div class=\"title\">" + std::regex_replace(options.outfile, std::regex("\\..*?$"), "") + "</div>";
	}
	const std::string footer = "<div class=\"footer\">\n\
			<i>Made using <a href=\"https://github.com/nonnymoose/xsr\">X Steps Recorder</a>.</i>\n\
		</div>\n\
	</body>\n\
</html>";
	namespace tags {
		const std::string instruction = "<div class=\"instruction\">";
		const std::string instruction_title = "<div class=\"title\">";
		const std::string div_end = "</div>";
		const std::string img_start = "<img src=\"data:";
		const std::string img_end = "\" />";
		const std::string app_start = " in <apptitle>";
		const std::string app_end = "</apptitle>";
	}
}
