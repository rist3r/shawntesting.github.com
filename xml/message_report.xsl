<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="html" indent="yes"/>
	<!-- Author:	         James Eaton -->
	<!-- Company:       Northrop Grumman Space & Mission Systems -->
	<!-- Supporting:     United States (US) Department of Defense (DoD), Defense Information Systems Agency (DISA) GE332 -->
	<!-- Last Modified: 1111 hours, 14 FEB 2007 -->
	<xsl:template match="/">
		<!-- Variable Declarations -->
		<!-- The 'statusDate' variable contains the Status Date (e.g. '31 Mar 2007', etc) because it is not contained in the XML-MTF schema -->
		<xsl:variable name="statusDate"></xsl:variable>
		<!-- The 'versionDate' variable contains the Version Date (e.g. '31 Mar 2007', etc) because it is not contained in the XML-MTF schema -->
		<xsl:variable name="versionDate"></xsl:variable>
		<!-- The 'classification' variable contains the Classification of the Message Text Format (i.e. 'U', 'C', 'S' or 'TS') because it is not contained in the XML-MTF schema -->
		<!-- As of  2008 , all US Message Text Formats are Unclassified, so this value has been hard coded as 'U' for lack of a dynamic method for obtaining this information. -->
		<xsl:variable name="classification">U</xsl:variable>
		<!-- The 'segmentLevel' variable contains an integer value representing the depth of the current segment structure (e.g. if you're in a tripple nested segment, 'segmentLevel' = 3) -->
		<xsl:variable name="segmentLevel">0</xsl:variable>
		<!-- <xsl:variable name="msgId"><xsl:value-of select="/xsd:schema/xsd:element/xsd:annotation/xsd:appinfo//*[name()='MtfIdentifier']"/></xsl:variable> -->
		<!-- End Variable Declarations -->
		<!-- HTML and XSLT -->
		<html>
			<head>
				<!-- CSS Stylesheet -->
				<link rel="stylesheet" type="text/css" href="./message_report.css"/>
				<!-- End CSS Stylesheet -->
				<title>USMTF Message <xsl:value-of select="	/xsd:schema/xsd:element/xsd:annotation/xsd:appinfo/*[name()='MtfIdentifier']"/>  Version <xsl:value-of select="/xsd:schema/xsd:element/xsd:annotation/xsd:appinfo/*[name()='VersionIndicator']"/></title>
				<script type="text/javascript"><![CDATA[  
  var xmldoc;
  var xsl;
  var cache;
  var transformer;

  //********************************
  //
  //
  //********************************
  function transformSchema(xsd, stylesheet, param1, param2)
  {
    // For Microsoft Internet Explorer ...
    if (window.ActiveXObject || "ActiveXObject" in window)
    {
      //Check for latest version of MSXML

      var sXMLVer = XMLVer();
      switch (sXMLVer) {
        case 'MSXML6':{
          xmldoc = new ActiveXObject("Msxml2.DOMDocument.6.0");
          xsl    = new ActiveXObject("Msxml2.FreeThreadedDOMDocument.6.0");
          cache  = new ActiveXObject("Msxml2.XSLTemplate.6.0");
          break;
        }
        case 'MSXML5':{
          xmldoc = new ActiveXObject("Msxml2.DOMDocument.5.0");
          xsl    = new ActiveXObject("Msxml2.FreeThreadedDOMDocument.5.0");
          cache  = new ActiveXObject("Msxml2.XSLTemplate.5.0");
          break;
        }
        case 'MSXML4':{
          xmldoc = new ActiveXObject("Msxml2.DOMDocument.4.0");
          xsl    = new ActiveXObject("Msxml2.FreeThreadedDOMDocument.4.0");
          cache  = new ActiveXObject("Msxml2.XSLTemplate.4.0");
          break;
        }
        case 'MSXML3':{
          xmldoc = new ActiveXObject("Msxml2.DOMDocument.3.0");
          xsl    = new ActiveXObject("Msxml2.FreeThreadedDOMDocument.3.0");
          cache  = new ActiveXObject("Msxml2.XSLTemplate.3.0");
          break;
        }
        case 'MSXML2':{
          xmldoc = new ActiveXObject("Msxml2.DOMDocument");
          xsl    = new ActiveXObject("Msxml2.FreeThreadedDOMDocument");
          cache  = new ActiveXObject("Msxml2.XSLTemplate");
          break;
        }
        default://if (oXMLVer.bMsxml1)
        {
          alert("MSXML version 2.6 or later is required.");
          return;
        }
      }

      var Err;
      xmldoc.async = false;
      xmldoc.load(xsd);

      if (xmldoc.parseError.errorCode != 0) {
        Err = xmldoc.parseError;
        alert("You have error when load schema: " + Err.reason);
      }
      else
      {
        // Load XSL
        xsl.async = false;
        xsl.setProperty("AllowDocumentFunction", true);
        xsl.load(stylesheet);

        if (xsl.parseError.errorCode != 0) {
          Err = xsl.parseError;
          alert("You have error when load stylesheet:" + Err.reason);
        }
        else
        {
          // Load XSLTemplate
          try {
            cache.stylesheet = xsl;
            transformer = cache.createProcessor();
            transformer.input = xmldoc;
            transformer.addParameter("selectedSetid", param2);
            transformer.addParameter("MsgId", param1);
            
            transformer.transform();
            document.write(transformer.output);
          }
          catch(e) {
            alert("You have error when transform: " + e.message);
          }
  //      document.close();
        }

        // 'Reload' the document to prevent need to click a link twice on next page
  //    document.location.reload();
      }
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
      proc.setParameter(null,"selectedSetid", param2);
      proc.setParameter(null,"MsgId", param1);
      var output = proc.transformToDocument(xml);

      // Convert from DOM syntax to XML syntax
      var xmls = new XMLSerializer();
      var outputString = xmls.serializeToString(output);

      // Output XML
      document.write(outputString);
    }
  } //End function

  //************************************************************
  //  This function returns the recent installed MSXML version
  //
  //************************************************************
  function XMLVer()
  {
    var sVer = "";

    //********************************
    //
    //********************************

    var oXML = null;
    try {
      oXML = new ActiveXObject("Msxml2.DOMDocument.6.0");
      oXML = null;
      sVer = "MSXML6";
      return sVer;
    }
    catch (e){
      try {
        oXML = new ActiveXObject("Msxml2.DOMDocument.5.0");
        oXML = null;
        sVer = "MSXML5";
        return sVer;
      }
      catch (e){
        try {
          oXML = new ActiveXObject("Msxml2.DOMDocument.4.0");
          oXML = null;
          sVer = "MSXML4";
          return sVer;
        }
        catch (e){
          try {
            oXML = new ActiveXObject("Msxml2.DOMDocument.3.0");
            oXML = null;
            sVer = "MSXML3";
            return sVer;
          }
          catch (e){
            try {
              oXML = new ActiveXObject("Msxml2.DOMDocument.2.0");
              oXML = null;
              sVer = "MSXML2";
              return sVer;
            }
            catch (e){
              try {
                oXML = new ActiveXObject("Msxml2.DOMDocument.1.0");
                oXML = null;
                sVer = "MSXML1";
                return sVer;
              }
              catch (e){
                sVer = "NOMSXML";
                return sVer;
              }
            }
          }
        }
      }
    }
  } //End function

  //************************************************************
  //  This function refreshes turns the recent installed MSXML version
  //
  //************************************************************
  function refreshform(SetId) {
    var xslproc = transformer.createProcessor();
    xslproc.input = xmldoc;
    xslproc.addParameter('SetId', SetId, '');
    xslproc.transform();
    document.write(xslproc.output);
  }

]]></script>
			</head>
			<!-- Begin Layout of Message Text Format Metadata -->
			<body>
				<div id="divMessageLevelData">
					<div style="border:solid 0px red;font-family:courier">
						<!--Chipman: 30Sep2016: Deleted "width:200;" from <div style=. Changed "float" to "clear". Moved location. Added break.-->
						<div style="border:solid 0px blue;clear:left;">
							<b>Classification: </b>
							<xsl:value-of select="$classification"/>
						</div>
						<br/>
						<!--Chipman: 30Sep2016: Deleted "width:700;" from <div style=. Changed "float" to "clear". Moved location. Added breaks.-->
						<div style="border:solid 0px blue;clear:left;">
							<b>Message Text Format Name: </b>
							<xsl:value-of select="/xsd:schema/xsd:element/xsd:annotation/xsd:appinfo/*[name()='MtfName']"/>
						</div>
						<br/>
						<!--Chipman: 30Sep2016: Deleted "width:350;" from <div style=. Moved location. Changed "float" to "clear". Added breaks.-->
						<div style="border:solid 0px blue;clear:left;">
							<b>MTF Identifier: </b>
							<xsl:value-of select="/xsd:schema/xsd:element/xsd:annotation/xsd:appinfo/*[name()='MtfIdentifier']"/>
						</div>
						<br/>
						<!--Chipman: 30Sep2016: Deleted "width:350;" from <div style=. Changed "float" to "clear". Capitalized heading.-->
						<div style="border:solid 0px black;clear:left;white-space:pre;">
							<b>Index Reference Number: </b>
							<xsl:value-of select="/xsd:schema/xsd:element/xsd:annotation/xsd:appinfo/*[name()='MtfIndexReferenceNumber']"/>
						</div>
						<!--Chipman: 30Sep2016: hid "Status: AGREED-->
						<!--<div style="width:350;border:solid 0px blue;float:left;">
							<b>Status:</b> AGREED</div>
						<div style="width:350;border:solid 0px blue;float:left;">
							<b></b>
							<xsl:value-of select="$statusDate"/>
						</div>-->
						<br/>
						<!--Chipman: 30Sep2016: Deleted "width:350;" from <div style=. Changed "float" to "clear". Added breaks.-->
						<div style="border:solid 0px blue;clear:left;">
							<b>Version: </b>
							<xsl:value-of select="/xsd:schema/xsd:element/xsd:annotation/xsd:appinfo/*[name()='VersionIndicator']"/>
						</div>
						<br/>
						<!--Chipman: 30Sep2016: Hid VersionDate. Deleted "width:350;" from <div style=.-->
						<!--<div style="border:solid 0px blue;float:left;">
							<b></b>
							<xsl:value-of select="$versionDate"/>
						</div>
						<br/>
						<br/>-->
						<!--Chipman: 30Sep2016: Deleted "width:900;" from <div style=.-->
						<div style="border:solid 0px blue;clear:left;">
						<!--<br/>-->
							<b>Purpose: </b>
							<xsl:value-of select="/xsd:schema/xsd:element/xsd:annotation/xsd:appinfo/*[name()='MtfPurpose']"/>
						</div>
						<br/>
						<!--Chipman: 30Sep2016: Deleted "width:900;" from <div style=.-->
						<div style="border:solid 0px blue;clear:left">
							<b>Message Notes: </b>
							<xsl:value-of select="/xsd:schema/xsd:element/xsd:annotation/xsd:appinfo/*[name()='MtfNote']"/>
						</div>
						<br/>
						<!--Chipman: 30Sep2016: Deleted "width:900;" from <div style=.-->
						<div style="border:solid 0px blue;clear:left;">
							<b>Related Documents: </b>
							<xsl:for-each select="/xsd:schema/xsd:element/xsd:annotation/xsd:appinfo/*[name()='MtfRelatedDocument']">
								<xsl:value-of select="."/>
								<br/>
							</xsl:for-each>
						</div>
						<br/>
						<!--Chipman: 30Sep2016: Deleted "width:650;" from <div style=.-->
						<div style="border:solid 0px blue;clear:left;">
							<b>Sponsors: </b>
							<xsl:value-of select="/xsd:schema/xsd:element/xsd:annotation/xsd:appinfo/*[name()='MtfSponsor']"/>
						</div>
						<br/>
						<!--Chipman: 30Sep2016: Deleted "width:900;" from <div style=. Changed "float" to "clear".-->
						<div style="border:solid 0px blue;clear:left;">
							<b>Remarks: </b>
							<xsl:value-of select="/xsd:schema/xsd:element/xsd:annotation/xsd:appinfo/*[name()='MtfRemark']"/>
						</div>
					</div>
				</div>
				<!-- End Layout of Message Text Format Metadata -->
				<!-- Begin Layout of Message Set Data -->
				<br/>
				<span style="CLEAR:left">
					<div id="transformSets">
<!--Chipman: 30Sep2016: deleted 3 breaks-->					
<!--<br/>
<br/>
<br/>-->


<table class='MsoNormalTable' border='0' cellpadding='5' style='mso-cellspacing:10pt; mso-padding-alt:0in 5.4pt 0in 5.4pt'>


      <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes'>
        <th style='background:#ffdd33; width:5.0%;padding:10pt'>
         
              <u>POS</u>
       
        </th>
        <th style='background:#ffdd33; width:5.0%;padding:10pt'>
          
              <u>SEG</u>
       
        </th>
        <th style='background:#ffdd33; width:5.0%;padding:10pt'>
              <u>RPT</u>
  
        </th>
        <th style='background:#ffdd33; width:5.0%;padding:10pt'>
              <u>OCC</u>
        </th>
        <th style='background:#ffdd33; width:20.0%;padding:10pt'>
              <u>SETPOSITION</u>
        </th>
	<th style='background:#ffdd33; width:5.0%;padding:10pt'>
             <u>SEQ</u>
        </th>
        <th style='background:#ffdd33; width:55.0%;padding:10pt'>
             <u>SET/SEGMENT USAGE</u>
         </th>
      </tr>



							<!-- Begin Message Set, Segment, and Alternative Format Position Logic -->
							<!-- Call template to process each Message Segment, Message Set, and Message Alternative Format Position -->
							<xsl:call-template name="message_segment_set_and_alternative_processor">
								<xsl:with-param name="path" select="/xsd:schema/xsd:element/xsd:complexType/xsd:sequence/child::*[name()='xsd:choice' or @name!='Remarks']"/>
								<xsl:with-param name="spanWidth" select="0"/>
								<xsl:with-param name="segmentLevel" select="0"/>
								<xsl:with-param name="positionValue" select="1"/>
							</xsl:call-template>
							<!-- End Message Set and Segment Logic -->
						</table>
					</div>
				</span>
				<!-- End  Layout of Message Set Data -->
				<!-- Begin Layout of Message Text Format Footer Metadata -->
				<br/>
				<br/>
				<!-- Begin Output Structural Notation -->
				<table id="SNTable" cellspacing="1" border="0">
					<!-- Output table header-->
					<tr>
						<td colspan="2" class="snleTableHeader">Structural Notation</td>
						<td/>
					</tr>
					<!-- Call template to process each line of SN -->
					<xsl:call-template name="structural_notation_output_processor"/>
					<!-- End template to process each line of SN -->
				</table>
				<!-- End Output Structural Notation -->
				<br/>
				<br/>
				<!-- Begin Output Structural Notation Explanation -->
				<table id="NLETable" cellspacing="1" border="0">
					<!-- Output table header-->
					<tr>
						<td colspan="2" class="snleTableHeader">Structural Language</td>
						<td/>
					</tr>
					<!-- Call template to process each line of SN Explanation -->
					<xsl:call-template name="structural_notation_explanation_output_processor"/>
					<!-- End template to process each line of SN Explanation -->
				</table>
			</body>
			<!-- End Output Structural Notation Explanation -->
			<!-- Message Example would normally go here, but examples are not included in the schema. -->
			<!-- End Layout of Message Text Format Footer Metadata -->
		</html>
		<!-- End HTML and XSLT -->
	</xsl:template>
	<!-- Begin Additional Template Definitions -->
	<!-- Begin template to process each Message Segment, Message Set, and Message Alternative Format Position -->
	<xsl:template name="message_segment_set_and_alternative_processor">
		<xsl:param name="path"/>
		<xsl:param name="spanWidth"/>
		<xsl:param name="segmentLevel"/>
		<xsl:param name="positionValue"/>
		<!-- The 'folderString' variable identifies the path to the schemas that are being processed so that the stylesheet can access the appropriate sets.xsd document.  -->
		<xsl:variable name="folderString" select="concat('./WithDoc/', /xsd:schema/xsd:element/xsd:complexType/xsd:attribute/@fixed, '/sets.xsd')"/>
		<xsl:for-each select="$path">
			<xsl:variable name="nPrecedingSegments" select="count(preceding-sibling::*[xsd:annotation/xsd:appinfo/*[name()='SegmentStructureName']])"/>
			<xsl:variable name="nSetsInPrecedingSegments">
				<xsl:choose>
					<xsl:when test="$nPrecedingSegments &gt;0">
						<xsl:call-template name="count_descendent_elements">
							<xsl:with-param name="path" select="preceding-sibling::*[xsd:annotation/xsd:appinfo/*[name()='SegmentStructureName']]"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="0"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="offset" select="number($nSetsInPrecedingSegments) - number($nPrecedingSegments)"/>
			<xsl:choose>
				<!-- This is the SEGMENT case -->
				<xsl:when test="xsd:annotation/xsd:appinfo/*[name()='SegmentStructureName']">
					<!-- Initial Segment Identification Row -->
					<tr style="background-color:#FFEEEE;vertical-align: top;">
						<td>
							<!-- Segment Positions do not have a Position number.  It's subordinate sets have Position numbers -->
							<!--<xsl:value-of select="$positionValue+ $offset + position()- 1"/>-->
						</td>
						<!-- Output the Occurrence Category of the Segment.  Depending on the value of the Occurrence Category, color the identifier one of the colors below. -->
						<xsl:choose>
							<!-- This is the Mandatory (M) case -->
							<xsl:when test="xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Mandatory'">
								<td style="color:red">
									<xsl:call-template name="output_segment_nesting_markers">
										<xsl:with-param name="segmentLevel" select="$segmentLevel"/>
									</xsl:call-template>
									M
								</td>
							</xsl:when>
							<!-- This is the Conditional (C) case -->
							<xsl:when test="xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Conditional'">
								<td style="color:#FFCC00">
									<xsl:call-template name="output_segment_nesting_markers">
										<xsl:with-param name="segmentLevel" select="$segmentLevel"/>
									</xsl:call-template>
									C
								</td>
							</xsl:when>
							<!-- This is the Operationally Determined (O) case -->
							<xsl:when test="xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Operationally Determined'">
								<td style="color:Green">
									<xsl:call-template name="output_segment_nesting_markers">
										<xsl:with-param name="segmentLevel" select="$segmentLevel"/>
									</xsl:call-template>
									O
								</td>
							</xsl:when>
							<!-- This is the default, catch-all case to handle any cases not already defined -->
							<xsl:otherwise>
								<td>
									<b>
										<br/>
										<font color="red">#ERR#</font>
										<br/>
									</b>
								</td>
							</xsl:otherwise>
						</xsl:choose>
						<!-- Segments are always repeatable by design.  The table dimension that would normally go here is absent because inherent repeatability is not indicated in the baseline reports -->
						<td colspan="4">
							<xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='SegmentStructureName']"/>
						</td>
						<td colspan="2">
							<xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='SegmentStructureUseDescription']"/>
						</td>
					</tr>
					<!-- Call template (recursively) to process each Subordinate Segment, Set, and Alternative Format Position -->
					<xsl:call-template name="message_segment_set_and_alternative_processor">
						<!-- This parameter passes the children of the current nodeset (i.e. the node set of MTF sets within the Alternative Format Position) for processing-->
						<xsl:with-param name="path" select="./xsd:complexType/xsd:sequence/child::*[name()!='xsd:annotation']"/>
						<!-- This parameter specifies the width to be used in the span preeceding the MTF Setid.  The increment is increased each time to indent further for each subordinate node of MTF sets -->
						<xsl:with-param name="spanWidth" select="$spanWidth"/>
						<!-- This parameter indicates whether the parser is currently in a segment and the count of segment nestings to the current position.  It allows for the programatic output of the correct number of '[' segment indicators in the table -->
						<xsl:with-param name="segmentLevel" select="$segmentLevel + 1"/>
						<!-- This parameter contains the last position value calculated before entering a segment.  It allows an accurate position number calculation within the segment -->
						<xsl:with-param name="positionValue" select="$positionValue + number($offset) + number(position() - 1)"/>
					</xsl:call-template>
					<!-- End template call (recursively) after processing each subordinate set -->
					<!-- Terminal Segment Identification Row -->
					<tr style="background-color:#FFEEEE;vertical-align: top;">
						<td>
							<!-- Empty table dimension by design -->
						</td>
						<td>
							<xsl:call-template name="output_segment_nesting_markers">
								<xsl:with-param name="segmentLevel" select="$segmentLevel"/>
							</xsl:call-template>*
						</td>
						<td colspan="6">END OF <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='SegmentStructureName']"/>
						</td>
					</tr>
				</xsl:when>
				<!-- This is the SET case -->
				<xsl:when test="xsd:annotation/xsd:appinfo/*[name()='SetFormatPositionName']">
					<tr style="vertical-align: top;">
						<td>
							<xsl:if test="$spanWidth &lt;= 0">
								<xsl:value-of select="$positionValue + $offset + position()-1"/>
								<br/>
							</xsl:if>
						</td>
						<td>
							<xsl:call-template name="output_segment_nesting_markers">
								<xsl:with-param name="segmentLevel" select="$segmentLevel"/>
							</xsl:call-template>
						</td>
						<!-- Output an "R" if the set is repeatable.  Output a " " (space) if the set is not repeatable. -->
						<xsl:choose>
							<xsl:when test="xsd:annotation/xsd:appinfo/*[name()='Repeatability']='1'">
								<td> </td>
							</xsl:when>
							<xsl:otherwise>
								<td>R</td>
							</xsl:otherwise>
						</xsl:choose>
						<!-- Determine if this is a nested set.  If so, do not ouput an occurrence category -->
						<xsl:choose>
							<xsl:when test="$spanWidth = 0">
								<!-- Output the Occurrence Category.  Depending on the value of the Occurrence Category, color the identifier one of the colors below. -->
								<xsl:choose>
									<!-- This is the Mandatory (M) case -->
									<xsl:when test="xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Mandatory'">
										<td style="color:red">
											<b>
												M
											</b>
										</td>
									</xsl:when>
									<!-- This is the Conditional (C) case -->
									<xsl:when test="xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Conditional'">
										<td style="color:#FFCC00">
											<b>
												C
											</b>
										</td>
									</xsl:when>
									<!-- This is the Operationally Determined (O) case -->
									<xsl:when test="xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Operationally Determined'">
										<td style="color:Green">
											<b>
												O
											</b>
										</td>
									</xsl:when>
									<!-- This is the default, catch-all case to handle any cases not already defined -->
									<xsl:otherwise>
										<td>
											<b>
												<font color="red">#ERR#</font>
											</b>
										</td>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<td/>
							</xsl:otherwise>
						</xsl:choose>
						<td>
							<span>
								<xsl:attribute name="style">width:<xsl:value-of select="$spanWidth"/></xsl:attribute>
							</span>
							<!-- The variable holds the name of the extention base (i.e. 'type') for the current set format within the message format -->
							<xsl:variable name="currentExtensionBase" select="xsd:complexType/xsd:complexContent/xsd:extension/@base"/>
							<xsl:variable name="MsgId">
								<xsl:value-of select="/xsd:schema/xsd:element/xsd:annotation/xsd:appinfo/*[name()='MtfIdentifier']"/>
							</xsl:variable>
							<xsl:for-each select="document($folderString)/xsd:schema/xsd:complexType">
								<xsl:if test="concat('s:', @name) = $currentExtensionBase">
									<!-- xsd:attribute/@fixed is the xPath for the EXER/OPER special case -->
									<xsl:variable name="passedSetid1">
										<xsl:value-of select="xsd:attribute/@fixed"/>
									</xsl:variable>
									<a href="javascript:transformSchema('{$folderString}', './set_report.xsl', '{$MsgId}', '{$passedSetid1}')">
										<xsl:value-of select="xsd:attribute/@fixed"/>
									</a>
									<!-- Alternately, xsd:complexContent/xsd:extension/xsd:attribute/@fixed is the xPath for the all other sets -->
									<xsl:variable name="passedSetid2">
										<xsl:value-of select="xsd:complexContent/xsd:extension/xsd:attribute/@fixed"/>
									</xsl:variable>
									<a href="javascript:transformSchema('{$folderString}', './set_report.xsl', '{$MsgId}', '{$passedSetid2}')">
										<xsl:value-of select="xsd:complexContent/xsd:extension/xsd:attribute/@fixed"/>
									</a>
								</xsl:if>
							</xsl:for-each>
						</td>
						<td>
							<xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='SetFormatPositionNumber']"/>
						</td>
						<td colspan="2">
							<xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='SetFormatPositionUseDescription']"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='SetFormatPositionConcept']"/>
						</td>
					</tr>
				</xsl:when>
				<!-- This is the ALTERNATIVE ForMAT POSITION case -->
				<xsl:when test="name(.)='xsd:choice'">
					<tr style="background-color:#FFFFEE;vertical-align: top;">
						<td>
							<!--<xsl:value-of select="$positionValue + position() - 1"/>-->
							<xsl:value-of select="$positionValue + $offset + position() - 1"/>
						</td>
						<td>
							<xsl:call-template name="output_segment_nesting_markers">
								<xsl:with-param name="segmentLevel" select="$segmentLevel"/>
							</xsl:call-template>
						</td>
						<td/>
						<xsl:choose>
							<!-- Handles all AFPs for Operationally Determined Sets, other than cases where sets are ALor -->
							<xsl:when test="xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Operationally Determined'">
								<td style="color:Green">
									<b>
										O
									</b>
								</td>
							</xsl:when>
							<!-- Handles all AFPs for Mandatory Sets, other than cases where sets are ALor -->
							<xsl:when test="xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Mandatory'">
								<td style="color:red">
									<b>
										M
									</b>
								</td>
							</xsl:when>
							<!-- Handles all AFPs for Conditional Sets, other than cases where sets are ALor -->
							<xsl:when test="xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Conditional'">
								<td style="color:#FFCC00">
									<b>
										C
									</b>
								</td>
							</xsl:when>
							<!-- Handles ALor AFPs for Operationally Determined Sets -->
							<xsl:when test="xsd:sequence/xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Operationally Determined'">
								<td style="color:Green">
									<b>
										O
									</b>
								</td>
							</xsl:when>
							<!-- Handles ALor AFPs for Mandatory Sets -->
							<xsl:when test="xsd:sequence/xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Mandatory'">
								<td style="color:red">
									<b>
										M
									</b>
								</td>
							</xsl:when>
							<!-- Handles ALor AFPs for Conditional Sets -->
							<xsl:when test="xsd:sequence/xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Conditional'">
								<td style="color:#FFCC00">
									<b>
										C
									</b>
								</td>
							</xsl:when>
							<!-- This is the default, catch-all case to handle any cases not already defined -->
							<xsl:otherwise>
								<b>
									<br/>
									<font color="red">OCCURRENCE CATEGorY PROCESSING ERRor</font>
									<br/>
								</b>
							</xsl:otherwise>
						</xsl:choose>
						<td>
							<!-- This contains similar code to the SET case, but reads each subordinate setid and outputs it delimited with pipes (|) -->
							<!-- This first for-each handles all cases except ALor -->
							<xsl:for-each select="xsd:element">
								<!-- Outputs a space-padded pipe (|) character to delimit the set options for the set format position if this itteration is not the first set to be listed -->
								<xsl:if test="preceding-sibling::*[name()!='xsd:annotation']">
									<xsl:text> | </xsl:text>
								</xsl:if>
								<!-- The variable holds the name of the extention base (i.e. 'type') for the current set format within the message format -->
								<xsl:variable name="currentExtensionBase" select="xsd:complexType/xsd:complexContent/xsd:extension/@base"/>
								<xsl:for-each select="document($folderString)/xsd:schema/xsd:complexType">
									<xsl:if test="concat('s:', @name) = $currentExtensionBase">
										<!-- xsd:attribute/@fixed is the xPath for the EXER/OPER special case -->
										<xsl:value-of select="xsd:attribute/@fixed"/>
										<!-- Alternately, xsd:complexContent/xsd:extension/xsd:attribute/@fixed is the xPath for the all other sets -->
										<xsl:value-of select="xsd:complexContent/xsd:extension/xsd:attribute/@fixed"/>
									</xsl:if>
								</xsl:for-each>
							</xsl:for-each>
							<!-- This second for-each handles ALor cases -->
							<xsl:for-each select="xsd:sequence[position()=1]/xsd:element">
								<!-- Outputs a space-padded pipe (|) character to delimit the set options for the set format position if this itteration is not the first set to be listed -->
								<xsl:if test="preceding-sibling::*[name()!='xsd:annotation']">
									<xsl:text> | </xsl:text>
								</xsl:if>
								<!-- The variable holds the name of the extention base (i.e. 'type') for the current set format within the message format -->
								<xsl:variable name="currentExtensionBase" select="xsd:complexType/xsd:complexContent/xsd:extension/@base"/>
								<xsl:for-each select="document($folderString)/xsd:schema/xsd:complexType">
									<xsl:if test="concat('s:', @name) = $currentExtensionBase">
										<!-- xsd:attribute/@fixed is the xPath for the EXER/OPER special case -->
										<xsl:value-of select="xsd:attribute/@fixed"/>
										<!-- Alternately, xsd:complexContent/xsd:extension/xsd:attribute/@fixed is the xPath for the all other sets -->
										<xsl:value-of select="xsd:complexContent/xsd:extension/xsd:attribute/@fixed"/>
									</xsl:if>
								</xsl:for-each>
							</xsl:for-each>
						</td>
						<td>
							<!-- Sequence numbers are not output for alternative format positions, therefore this field is left blank -->
						</td>
						<td colspan="2">
							<!-- This xsl:choose determines MEN (Opperationally Determined), MEO (Mandatory), or ALor (Conditional) and outputs the beginning string of text for the explanation. -->
							<xsl:choose>
								<!-- This outputs the beginning text for all Operationally Determined AFPs, except ALors -->
								<xsl:when test="xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Operationally Determined'">
									THE&#x20;
								</xsl:when>
								<!-- This outputs the beginning text for all Mandatory AFPs, except ALors -->
								<xsl:when test="xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Mandatory'">
									THE USE OF&#x20;
								</xsl:when>
								<!-- This outputs the beginning text for all Mandatory AFPs, except ALors -->
								<xsl:when test="xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Conditional'">
									AT LEAST ONE OF THE&#x20;
								</xsl:when>
								<!-- This outputs the beginning text for ALor Operationally Determined AFPs -->
								<xsl:when test="xsd:sequence[position()=1]/xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Operationally Determined'">
									THE&#x20;
								</xsl:when>
								<!-- This outputs the beginning text for ALor Mandatory AFPs -->
								<xsl:when test="xsd:sequence[position()=1]/xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Mandatory'">
									THE USE OF&#x20;
								</xsl:when>
								<!-- This outputs the beginning text for ALor Conditional AFPs -->
								<xsl:when test="xsd:sequence[position()=1]/xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Conditional'">
									AT LEAST ONE OF THE&#x20;
								</xsl:when>
							</xsl:choose>
							<!-- This reads each subordinate setid and output it delimited with commas (,) -->
							<!-- This handles non-ALor AFPs -->
							<xsl:for-each select="xsd:element">
								<!-- Outputs a space-padded pipe (|) character to delimit the set options for the set format position if this itteration is not the first set to be listed -->
								<xsl:if test="preceding-sibling::*[name()!='xsd:annotation']">
									<xsl:text>, </xsl:text>
								</xsl:if>
								<!-- The variable holds the name of the extention base (i.e. 'type') for the current set format within the message format -->
								<xsl:variable name="currentExtensionBase" select="xsd:complexType/xsd:complexContent/xsd:extension/@base"/>
								<xsl:for-each select="document($folderString)/xsd:schema/xsd:complexType">
									<xsl:if test="concat('s:', @name) = $currentExtensionBase">
										<!-- xsd:attribute/@fixed is the xPath for the EXER/OPER special case -->
										<xsl:value-of select="xsd:attribute/@fixed"/>
										<!-- Alternately, xsd:complexContent/xsd:extension/xsd:attribute/@fixed is the xPath for the all other sets -->
										<xsl:value-of select="xsd:complexContent/xsd:extension/xsd:attribute/@fixed"/>
									</xsl:if>
								</xsl:for-each>
							</xsl:for-each>
							<!-- This handles ALor AFPs -->
							<xsl:for-each select="xsd:sequence[position()=1]/xsd:element">
								<!-- Outputs a space-padded pipe (|) character to delimit the set options for the set format position if this itteration is not the first set to be listed -->
								<xsl:if test="preceding-sibling::*[name()!='xsd:annotation']">
									<xsl:text>, </xsl:text>
								</xsl:if>
								<!-- The variable holds the name of the extention base (i.e. 'type') for the current set format within the message format -->
								<xsl:variable name="currentExtensionBase" select="xsd:complexType/xsd:complexContent/xsd:extension/@base"/>
								<xsl:for-each select="document($folderString)/xsd:schema/xsd:complexType">
									<xsl:if test="concat('s:', @name) = $currentExtensionBase">
										<!-- xsd:attribute/@fixed is the xPath for the EXER/OPER special case -->
										<xsl:value-of select="xsd:attribute/@fixed"/>
										<!-- Alternately, xsd:complexContent/xsd:extension/xsd:attribute/@fixed is the xPath for the all other sets -->
										<xsl:value-of select="xsd:complexContent/xsd:extension/xsd:attribute/@fixed"/>
									</xsl:if>
								</xsl:for-each>
							</xsl:for-each>
							<!-- This xsl:choose determines MEN (Opperationally Determined), MEO (Mandatory), or ALor (Conditional) and outputs the ending string of text for the explanation. -->
							<!-- This handles all but ALors -->
							<xsl:choose>
								<xsl:when test="xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Operationally Determined'">
									 &#x20;SETS ARE MUTUALLY EXCLUSIVE WITH NONE REQUIRED.
								</xsl:when>
								<xsl:when test="xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Mandatory'">
									 &#x20;SETS IS MUTUALLY EXCLUSIVE WITH ONE REQUIRED.
								</xsl:when>
								<xsl:when test="xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Conditional'">
									&#x20;SETS MUST BE USED. ALL MAY BE USED.
								</xsl:when>
								<!-- This handles ALors -->
								<xsl:when test="xsd:sequence[position()=1]/xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Operationally Determined'">
									 &#x20;SETS ARE MUTUALLY EXCLUSIVE WITH NONE REQUIRED.
								</xsl:when>
								<xsl:when test="xsd:sequence[position()=1]/xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Mandatory' or 'M'">
									 &#x20;SETS IS MUTUALLY EXCLUSIVE WITH ONE REQUIRED.
								</xsl:when>
								<xsl:when test="xsd:sequence[position()=1]/xsd:element/xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']='Conditional' or 'C'">
									&#x20;SETS MUST BE USED. ALL MAY BE USED.
								</xsl:when>
							</xsl:choose>
						</td>
					</tr>
					<xsl:choose>
						<xsl:when test="xsd:element">
							<!-- Call template (recursively) to process each subordinate set -->
							<xsl:call-template name="message_segment_set_and_alternative_processor">
								<!-- This parameter passes the children of the current nodeset (i.e. the node set of MTF sets within the Alternative Format Position) for processing-->
								<xsl:with-param name="path" select="./child::*[name()!='xsd:annotation']"/>
								<!-- This parameter specifies the width to be used in the span preeceding the MTF Setid.  The increment is increased each time to indent further for each subordinate node of MTF sets -->
								<xsl:with-param name="spanWidth" select="$spanWidth + 30"/>
							</xsl:call-template>
							<!-- End template call (recursively) after processing each subordinate set -->
						</xsl:when>
						<xsl:when test="xsd:sequence">
							<!-- Call template (recursively) to process each subordinate set -->
							<xsl:call-template name="message_segment_set_and_alternative_processor">
								<!-- This parameter passes the children of the current nodeset (i.e. the node set of MTF sets within the Alternative Format Position) for processing-->
								<xsl:with-param name="path" select="./xsd:sequence[position()=1]/child::*[name()!='xsd:annotation']"/>
								<!-- This parameter specifies the width to be used in the span preeceding the MTF Setid.  The increment is increased each time to indent further for each subordinate node of MTF sets -->
								<xsl:with-param name="spanWidth" select="$spanWidth + 30"/>
							</xsl:call-template>
							<!-- End template call (recursively) after processing each subordinate set -->
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				<!-- This is the REMARKS SET case -->
				<xsl:when test="@name='Remarks'">
					<!-- Take No Action -->
					<!-- The occurrence of the Remarks set element in the schema has to be handled, but it is not output to the Baseline Report -->
					<!-- If the occurrence of the Remarks set element is not handled, the XSLT will output the error in the 'xsl:otherwise' case -->
				</xsl:when>
				<!-- This is the DEFAULT CASE, catch-all case to handle any cases not already defined -->
				<xsl:otherwise>
					<tr>
						<td colspan="7">
							<b>
								<br/>
								<font color="red">PROCESSING ERRor</font>
								<br/>PATH: <xsl:value-of select="$path"/>
								<br/>
                LEVEL: <xsl:value-of select="$segmentLevel"/> - POSITION VALUE: <xsl:value-of select="$positionValue"/>
								<br/>
							</b>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<!-- End template to process each Message Segment, Message Set, and Message Alternative Format Position -->
	<!-- Begin template to output '[' segment nesting markers -->
	<xsl:template name="output_segment_nesting_markers">
		<xsl:param name="segmentLevel"/>
		<xsl:if test="number($segmentLevel) >= 1">
			<xsl:text>[</xsl:text>
			<xsl:call-template name="output_segment_nesting_markers">
				<xsl:with-param name="segmentLevel" select="$segmentLevel -1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- End template to output '[' segment nesting markers -->
	<!-- Begin template to process each SN statement -->
	<xsl:template name="structural_notation_output_processor">
		<xsl:for-each select="//*[name()='MtfStructuralRelationshipRule']">
			<tr>
				<td width="30" class="snleCells" style="vertical-align: top">
					<xsl:value-of select="position()"/>
					<xsl:text>.</xsl:text>
				</td>
				<td class="snleCells">
					<xsl:value-of select="."/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- End template to process each SN statement -->
	<!-- Begin template to process each SN explanation statement -->
	<xsl:template name="structural_notation_explanation_output_processor">
		<xsl:for-each select="//*[name()='MtfStructuralRelationshipExplanation']">
			<tr>
				<td width="30" class="snleCells" style="vertical-align: top">
					<xsl:value-of select="position()"/>
					<xsl:text>.</xsl:text>
				</td>
				<td class="snleCells">
					<xsl:value-of select="."/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- End template to process each SN explanation statement -->
	<!-- Begin template to count number of descendent sets -->
	<xsl:template name="count_descendent_elements">
		<xsl:param name="path"/>
		<xsl:choose>
			<xsl:when test="count($path)>0">
				<xsl:variable name="first" select="$path[1]"/>
				<xsl:variable name="rest" select="$path[position()>1]"/>
				<!--<xsl:for-each select="$path/xsd:complexType/xsd:sequence/child::*[name()!='xsd:annotation']">-->
				<xsl:variable name="countFirst">
					<xsl:for-each select="$first">
						<xsl:choose>
							<xsl:when test="xsd:annotation/xsd:appinfo/*[name()='SegmentStructureName']">
								<xsl:variable name="countdescendent">
									<xsl:call-template name="count_descendent_elements">
										<xsl:with-param name="path" select="./xsd:complexType/xsd:sequence/child::*[name()!='xsd:annotation']"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:value-of select="$countdescendent"/>
							</xsl:when>
							<xsl:when test="xsd:annotation/xsd:appinfo/*[name()='SetFormatPositionName']">
								<xsl:value-of select="1"/>
							</xsl:when>
							<xsl:when test="name(.)='xsd:choice'">
								<xsl:value-of select="1"/>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="countRest">
					<xsl:choose>
						<xsl:when test="count($rest)>0">
							<xsl:call-template name="count_descendent_elements">
								<xsl:with-param name="path" select="$rest"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="number($countFirst) + number($countRest)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- End template to count number of children sets -->
	<!-- End Additional Template Definitions -->
</xsl:stylesheet>
