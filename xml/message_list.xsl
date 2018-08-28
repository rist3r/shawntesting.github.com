<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="html" indent="yes"/>
	<!-- Author:	         James Eaton -->
	<!-- Company:       Northrop Grumman Space & Mission Systems -->
	<!-- Supporting:     United States (US) Department of Defense (DoD), Defense Information Systems Agency (DISA) GE332 -->
	<!-- Last Modified: 0824 hours, 26 JAN 2007 -->
	<xsl:template match="/">
		<html>
			<!-- CSS Stylesheet -->
			<link rel="stylesheet" type="text/css" href="./message_list.css"/>
			<!-- End CSS Stylesheet -->
			<!-- Variable Declarations -->
			<!-- End Variable Declarations -->
			<!-- HTML and XSLT -->
			<head>
				<title>USMTF MIL-STD 6040B(Ch1) - Presentation Capabilities Format (PCF) Message List</title>
				<script type="text/javascript">
					function transformSchema(xsd, stylesheet) {
						// For Microsoft Internet Explorer ...
						if (window.ActiveXObject || "ActiveXObject" in window) {
							// Load XML
							var xml = new ActiveXObject("Microsoft.XMLDOM");
							xml.async = false;
							xml.load(xsd);
			
							// Load XSL
							var xsl = new ActiveXObject("Microsoft.XMLDOM");
							xsl.async = false;
							xsl.load(stylesheet);
			
							// Transform and Output
							document.write(xml.transformNode(xsl));

							// 'Reload' the document to prevent need to click a link twice on next page
							document.location.reload();

						}
						// For Other Browsers (Mozilla Firefox, Netscape ...)
						else {
							// Load XML
							var xml = document.implementation.createDocument("", "", null);
							xml.async = false;
							xml.load(xsd);
			
							// Load XSL
							var xsl = document.implementation.createDocument("", "", null);
							xsl.async = false;
							xsl.load(stylesheet);
			
							// Create Processor and Transform XML
							var proc = new XSLTProcessor();
							proc.importStylesheet(xsl);
							var output = proc.transformToDocument(xml);
			
							// Convert from DOM syntax to XML syntax
							var xmls = new XMLSerializer();
							var outputString = xmls.serializeToString(output);
			
							// Output XML
							document.write(outputString);
						}
					}
				</script>
			</head>
			<body>
				<td>
					<b>XML-MTF MESSAGE CATALOG (AS OF: 31 JUL 2018)</b>
				</td>
				<!-- Begin the Table to Hold the List of Messages -->
				<table cellpadding="10" border="0" style="line-height:180%">
					<tr>
						<td style="width:200px;">
							<u>MSGID</u>
						</td>
						<td>
							<u>MESSAGE TEXT FORMAT NAME</u>
						</td>
						<td>
							<u>MESSAGE NUMBER</u>
						</td>
						<td>
							<u>VERSION NUMBER</u>
						</td>
						<td>
							<u>VERSION DATE</u>
						</td>
					</tr>
					<xsl:call-template name="msg_list_processor"/>
				</table>
				<!-- End the Table to Hold the List of Messages -->
			</body>
		</html>
	</xsl:template>
	<!-- Begin Template to Process Each Set -->
	<xsl:template name="msg_list_processor">
		<xsl:for-each select="MTF/msg">
			<xsl:variable name="msgid" select="msgid"/>
			<xsl:variable name="xsdString" select="concat('./WithDoc/',$msgid,'/messages.xsd')"/>
			<xsl:if test="position() mod 2 = 0">
				<tr>
					<td style="width:200px;">
						<a href="javascript:transformSchema('{$xsdString}','./message_report.xsl')">
							<xsl:value-of select="msgid"/>
						</a>
					</td>
					<td>
						<a href="javascript:transformSchema('{$xsdString}', './message_report.xsl')">
							<xsl:value-of select="name"/>
						</a>
					</td>
					<td>
						<a href="javascript:transformSchema('{$xsdString}', './message_report.xsl')">
							<xsl:value-of select="index"/>
						</a>
					</td>
					<td>
						<a href="javascript:transformSchema('{$xsdString}', './message_report.xsl')">
							<xsl:value-of select="version"/>
						</a>
					</td>
					<td>
						<a href="javascript:transformSchema('{$xsdString}', './message_report.xsl')">
							<xsl:value-of select="date"/>
						</a>
					</td>
					<td>


					</td>
				</tr>
			</xsl:if>
			<xsl:if test="position() mod 2 != 0">
				<tr>
					<td style="width:200px;background-color:Honeydew;">
						<a href="javascript:transformSchema('{$xsdString}','./message_report.xsl')">
							<xsl:value-of select="$msgid"/>
						</a>
					</td>
					<td style="background-color:Honeydew;">
						<a href="javascript:transformSchema('{$xsdString}', './message_report.xsl')">
							<xsl:value-of select="name"/>
						</a>
					</td>
					<td style="background-color:Honeydew;">
						<a href="javascript:transformSchema('{$xsdString}', './message_report.xsl')">
							<xsl:value-of select="index"/>
						</a>
					</td>
					<td style="background-color:Honeydew;">
						<a href="javascript:transformSchema('{$xsdString}', './message_report.xsl')">
							<xsl:value-of select="version"/>
						</a>
					</td>
					<td style="background-color:Honeydew;">
						<a href="javascript:transformSchema('{$xsdString}', './message_report.xsl')">
							<xsl:value-of select="date"/>
						</a>
					</td>
					<td style="background-color:Honeydew;">
					
					</td>
				</tr>
			</xsl:if>
			<!-- End XSLT to alternate row colors. -->
		</xsl:for-each>
	</xsl:template>
	<!-- End Template to Process Each Set -->
</xsl:stylesheet>
