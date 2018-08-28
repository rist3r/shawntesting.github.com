<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="html" indent="yes"/>
	<!-- Author:	         James Eaton -->
	<!-- Company:       Northrop Grumman Space & Mission Systems -->
	<!-- Supporting:     United States (US) Department of Defense (DoD), Defense Information Systems Agency (DISA) GE332 -->
	<!-- Last Modified: 0824 hours, 26 JAN 2007 -->
  <xsl:param name="selectedSetid"/>
  <xsl:param name="MsgId"/>
	<xsl:template match="/">
		<!-- Variable Declarations -->
		<!-- The 'statusDate' variable contains the Status Date (e.g. '31 Mar 2007', etc) because it is not contained in the XML-MTF schema -->
		<!-- xsl:variable name="statusDate">31 Mar 2009</xsl:variable -->
		<!-- The 'versionDate' variable contains the Version Date (e.g. '31 Mar 2007', etc) because it is not contained in the XML-MTF schema -->
		<!-- xsl:variable name="versionDate">31 Dec 2008</xsl:variable -->
		<!-- The 'classification' variable contains the Classification of the Message Text Format (i.e. 'U', 'C', 'S' or 'TS') because it is not contained in the XML-MTF schema -->
		<!-- As of the 2008 Baseline, all US Message Text Formats are Unclassified, so this value has been hard coded as 'U' for lack of a dynamic method for obtaining this information. -->
		<xsl:variable name="classification">UNCLASSIFIED</xsl:variable>
    <xsl:variable name="folderString" select="concat('./WithDoc/', $MsgId)"/>
            
		<!-- End Variable Declarations -->
		<!-- HTML and XSLT -->
	<html>
	<head>
    <!-- CSS Stylesheet -->
    <link rel="stylesheet" type="text/css" href="./set_report.css"/>
    <!-- End CSS Stylesheet -->
    
	<title>USMTF <xsl:value-of select="$selectedSetid"/> Set Version <xsl:value-of select="/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*[name()='SetFormatIdentifier']=$selectedSetid]/xsd:annotation/xsd:appinfo/*[name()='VersionIndicator']"/></title>

    <script type="text/javascript">
      <![CDATA[  
  var xmldoc;
  var xsl;
  var cache;
  var transformer;
  
  
  //********************************
  //
  //
  //********************************
  function GetEnumList(fieldNameType, path)
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
      xmldoc.load(path);

      if (xmldoc.parseError.errorCode != 0) {
        Err = xmldoc.parseError;
        alert("You have error when loading schema " + path + ": " + Err.reason);
      }
      else
      {
        // Load XSL
        xsl.async = false;
        xsl.setProperty("AllowDocumentFunction", true);
        xsl.load("EnumList.xsl");

        if (xsl.parseError.errorCode != 0) {
          Err = xsl.parseError;
          alert("You have error when loading stylesheet:" + Err.reason);
        }
        else
        {
          // Load XSLTemplate
          try {
            cache.stylesheet = xsl;
            transformer = cache.createProcessor();
            transformer.input = xmldoc;
            transformer.addParameter("fieldNameType", fieldNameType);
            
            transformer.transform();
            var newDoc = document.open("text/html");
            newDoc.write(transformer.output);
            newDoc.close();
            //document.write(transformer.output);
            //document.close();
            
          }
          catch(e) {
            alert("You have error when transform: " + e.message);
          }
          document.close();
        }

        // 'Reload' the document to prevent need to click a link twice on next page
        document.location.reload();
      }
    }
    // For Other Browsers (Mozilla Firefox, Netscape ...)
    else {
      // Load XML
      var xml = document.implementation.createDocument("", "", null);
      xml.async = false;
      xml.load(path);

      // Load XSL
      var xsl = document.implementation.createDocument("", "", null);
      xsl.async = false;
      xsl.load("EnumList.xsl");

      // Create Processor and Transform XML
      var proc = new XSLTProcessor();
      proc.importStylesheet(xsl);
      proc.setParameter(null, "fieldNameType", fieldNameType);
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
  //  This function returns the recent installed MSXML version
  //
  //************************************************************
  function refreshform(SetId) {
    var xslproc = transformer.createProcessor();
    xslproc.input = xml;
    xslproc.addParameter('SetId', SetId, '');
    xslproc.transform();
    document.write(xslproc.output);
  }

]]>
    </script>  
	</head>
	<!-- Begin Layout of Set Format -->
	<body>
	<!-- Begin outputting the set format header information -->
    <div id="scrolling" style="overflow:auto">
	    <br/>
	    <div id="divSetLevelData">
        <!--div style="width:350;border:solid 0px black;float:left;white-space:pre;"-->
        <span class="Label">
          <xsl:value-of select="$classification"/>
        </span>
        <!--/div-->
        <table class="MsoTableGrid" border="0" cellspacing="5" cellpadding="5" style='mso-fti-tbllook:191;mso-padding-alt:0in 5.4pt 0in 5.4pt'>

<!--table class="MsoTableGrid" border="0" cellspacing="5" cellpadding="5"-->

          <tr>
            <td valign='top' style='width:3.05in;padding:0in 5.4pt 0in 5.4pt'>
              <!--<div style="width:350;border:solid 0px black;float:left;white-space:pre;">-->
                <span class='Label'>SET FORMAT IDENTIFIER: </span>
                <span class="Data">
                  <xsl:value-of select="$selectedSetid"/>
                </span>
              <!--</div>-->
            </td>
            <td valign="top" style='width:235.8pt;padding:0in 5.4pt 0in 5.4pt'>
              <p class='MsoNormal' align='center' style='text-align:center'>
                <b><!-- span  style='font-family:"Courier New"'>MIL-STD-6040</span --></b>
              </p>
            </td>
            <td valign="top" style='width:203.4pt;padding:0in 5.4pt 0in 5.4pt'>
              <p class='MsoNormal'>
                <!--<div style="width:300;border:solid 0px black;float:left;white-space:pre;">-->
                  <span class="Label">STATUS: </span>
                  <span class="Data"> AGREED</span>
                <!--</div>-->
              </p>
              <p class='MsoNormal'>
                <!--<div style="width:350;border:solid 0px black;float:left;white-space:pre;">-->
                  <!-- span class="Label">RELEASE DATE: </span -->
                  <span class="Data" style="">
                    <!-- xsl:value-of select="$statusDate"/ -->
                  </span>
                <!--</div>-->
              </p>
            </td>
          </tr>
          <tr>
            <td colspan='2' valign='top' style='width:455.4pt;padding:0in 5.4pt 0in 5.4pt'>
              <p class='MsoNormal'>
                <!--<div style="width:650;border:solid 0px black;float:left;white-space:pre;">-->
                  <span class="Label">SET FORMAT NAME: </span>
                  <span class="Data">
                    <xsl:value-of select="/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*[name()='SetFormatIdentifier']=$selectedSetid]/xsd:annotation/xsd:appinfo/*[name()='SetFormatName']"/>
                  </span>
                <!--</div>-->
              </p>
            </td>
            <td valign='top' style='width:203.4pt;padding:0in 5.4pt 0in 5.4pt'>
              <p class='MsoNormal'>
                <!--<div style="width:350;border:solid 0px black;float:left;white-space:pre;">-->
                  <span class="Label">VERSION:</span>
                  <span class="Data" style="">
                    <xsl:value-of select="/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*[name()='SetFormatIdentifier']=$selectedSetid]/xsd:annotation/xsd:appinfo/*[name()='VersionIndicator']"/>
                  </span>
                <!--</div>-->
              </p>
              <p class='MsoNormal'>
                <!--<div style="width:350;border:solid 0px black;float:left;white-space:pre;">-->
                  <!-- span class="Label">VERSION DATE:</span -->
                  <span class="Data" style="">
                    <!-- xsl:value-of select="$versionDate"/ -->
                  </span>
                <!--</div>-->
              </p>
            </td>
          </tr>
        </table>
        <br/>
        <br/>
        <div style="width:900;border:solid 0px black;float:left;white-space:pre;">
          <span class="Label">SPONSORS:</span>
          <span class="Data" style="">
    		    <xsl:value-of select="/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*[name()='SetFormatIdentifier']=$selectedSetid]/xsd:annotation/xsd:appinfo/*[name()='SetFormatSponsor']"/>
	        </span>
	      </div>
        <br/>
        <br/>
        <!--div style="width:900;border:solid 0px black;float:left;white-space:pre;"-->
         <div style="width:900;border:solid 0px blue;clear:left">
						
          <span class="Label">REMARKS:</span>
	
          <span class="Data" style="">
    		    <xsl:value-of select="/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*[name()='SetFormatIdentifier']=$selectedSetid]/xsd:annotation/xsd:appinfo/*[name()='SetFormatRemark']"/>
	        </span>
	      </div>
        <br/>
        <br/><div style="width:900;border:solid 0px black;float:left;white-space:pre;">
            <span class="Label">RELATED DOCUMENTS:</span>
            <span class="Data" style="">
    	        <xsl:for-each select="/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*[name()='SetFormatIdentifier']=$selectedSetid]/xsd:annotation/xsd:appinfo/*[name()='SetFormatRelatedDocuments']">
      			    <xsl:value-of select="."/>
		            <br/>

	            </xsl:for-each>
            </span>
        </div>
        <br/>

        <br/>
       <div style="width:900;border:solid 0px blue;clear:left">
          <!--<p class='MsoNormal' style="white-space:pre">-->
          <span class="Label">SET FORMAT NOTE:</span>
          <br/>
          <span class="Data" style="">
            <xsl:value-of select="/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*[name()='SetFormatIdentifier']=$selectedSetid]/xsd:annotation/xsd:appinfo/*[name()='SetFormatNote']"/>
          </span>
       </div>
         <br/>

         <div style="width:900;border:solid 0px black;float:left;white-space:pre;">

	         <span class="Label">EXAMPLE:</span>
	        <br/>
	        <span class="Data" style="">
            <xsl:call-template name="break">
              <xsl:with-param name="text">
                <xsl:for-each select="/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*[name()='SetFormatIdentifier']=$selectedSetid]/xsd:annotation/xsd:appinfo/*[name()='SetFormatExample']">
				 <xsl:value-of select="."/>
				  </xsl:for-each>
              </xsl:with-param>
            </xsl:call-template>	    	    
          </span>
	<br/>
	<br/>
      </div>
      </div>
	    <hr style="CLEAR:left;WIDTH:99%;COLOR:black"/>
    </div>
    <br/>
    <br/>
		<!-- End outputting the set format header information -->

    <!--table class='MsoNormalTable' border='1' cellpadding='0' style='border-collapse:collapse; mso-cellspacing:1.5pt; mso-padding-alt:0in 5.4pt 0in 5.4pt'-->
    <table class='MsoNormalTable' border='1' cellpadding='0' style='mso-cellspacing:1.5pt; mso-padding-alt:0in 5.4pt 0in 5.4pt'>


      <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes'>
        <th width="5%" style='background:#ffdd33; width:5.0%;padding:16pt'>
          <p class='MsoNormal'>
            <span style='font-family:"Courier New";font-weight:bold'>
              NO
            </span>
          </p>
        </th>
        <th width="2%" style='background:#ffdd33; width:2.0%;padding:16pt'>
          <p class='MsoNormal'>
            <span style='font-family:"Courier New";font-weight:bold'>
              OCC
            </span>
          </p>
        </th>
        <th width="25%" style='background:#ffdd33; width:25.0%;padding:16pt'>
          <p class='MsoNormal'>
            <span style='font-family:"Courier New";font-weight:bold'>
              DESIGNATOR
            </span>
          </p>
        </th>
        <th width="50%" style='background:#ffdd33; width:50.0%;padding:16pt'>
          <p class='MsoNormal'>
            <span style='font-family:"Courier New";font-weight:bold'>
              EXPLANATION /
              ALLOWED FORMATS / EXAMPLES
            </span>
          </p>
        </th>
        <th width="10%" style='background:#ffdd33; width:10.0%;padding:16pt'>
          <p class='MsoNormal'>
            <span style='font-family:"Courier New";font-weight:bold'>
              FLD-DESC
            </span>
          </p>
        </th>
      </tr>

      <xsl:choose>
        <xsl:when test="/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*[name()='SetFormatIdentifier']=$selectedSetid]/xsd:complexContent/xsd:extension/xsd:sequence/xsd:element">
          <xsl:for-each select="/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*[name()='SetFormatIdentifier']=$selectedSetid]/xsd:complexContent/xsd:extension/xsd:sequence/xsd:element">
              <xsl:variable name="FFPosConcept" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionConcept']"/>
              <xsl:variable name="fbase" select="concat('f:', @name, 'Type')"/>
          	  <xsl:variable name="cbase" select="concat('c:', @name, 'Type')"/>
              <xsl:variable name="fRef" select="concat($folderString, '/fields.xsd')"/>
              <xsl:variable name="cRef" select="concat($folderString, '/composites.xsd')"/>

              <xsl:choose>
              <xsl:when test="xsd:complexType/xsd:simpleContent/xsd:extension">
                <xsl:variable name="FldDesc" select="xsd:annotation/xsd:appinfo/*[name()='FieldDescriptor']" />
                <xsl:call-template name="tFieldFormatPositionEntry">
                  <!-- This parameter passes the position number of the field format position -->
                  <xsl:with-param name="FFPosNumber" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionNumber']"/>
                  <!-- This parameter specifies the occurrence category of the Field Format position -->
                  <xsl:with-param name="OccurrenceCategory" select="xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']"/>
                  <!-- This parameter specifies the name of the Field Format position -->
                  <xsl:with-param name="FFPosName" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionName']"/>
                </xsl:call-template>
                <xsl:variable name="fExtBase1" select="xsd:complexType/xsd:simpleContent/xsd:extension/@base"/>
                <xsl:choose>
                  <xsl:when test="count(document($fRef)/xsd:schema/xsd:simpleType[concat('f:', @name) = $fExtBase1]) > 0">
                    <xsl:for-each select="document($fRef)/xsd:schema/xsd:simpleType[concat('f:', @name) = $fExtBase1]">
                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <span style='font-family:"Courier New"'>
                            <xsl:choose>
                              <xsl:when test="xsd:restriction[@base='xsd:string']/xsd:pattern">
                                <!--<a href="./UnderConstruction.htm">
                                  <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudName']"/>
                                </a>
                                <br/>                                
                                <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudExplanation']"/>-->
                                <xsl:value-of select="$FFPosConcept"/>
                                <br/><br/>
                                ALLOWABLE ENTRIES: <span style="color:maroon"><xsl:value-of select="xsd:restriction/xsd:pattern/@value"/>
                                  <br/><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:documentation"/>
                                  <br/>
                                </span>
                              </xsl:when>
                              <xsl:when test="count(xsd:restriction[@base='xsd:string']/xsd:enumeration) = 1">
                                <xsl:value-of select="$FFPosConcept"/>
                                <br/><br/>
                                ALLOWABLE ENTRIES: <span style="color:maroon">
                                  <xsl:value-of select="xsd:restriction/xsd:enumeration/@value"/>
                                </span>
                                <br/>
                              </xsl:when>
                              <xsl:when test="count(xsd:restriction[@base='xsd:string']/xsd:enumeration)>1">
                                <xsl:variable name="fieldNameType" select="@name"/>
                                <xsl:value-of select="$FFPosConcept"/>
                                <br/>
                                Click <a href="javascript:GetEnumList('{$fieldNameType}', '{$fRef}')">here</a> for the list of allowable values.
                              </xsl:when>
                              <xsl:when test="xsd:restriction[@base='xsd:integer']/xsd:pattern">
                                <xsl:value-of select="$FFPosConcept"/>
                                <br/><br/>
                                ALLOWABLE ENTRIES: INTEGER<br/>
                                Min Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MinimumLength']"/><br/>
                                Max Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MaximumLength']"/><br/>
                                Range: (<xsl:value-of select="xsd:restriction[@base='xsd:integer']/xsd:minInclusive/@value"/> through <xsl:value-of select="xsd:restriction[@base='xsd:integer']/xsd:maxInclusive/@value"/>).
                                <br/>
                              </xsl:when>
                              <xsl:when test="xsd:restriction[@base='xsd:decimal']/xsd:pattern">
                                <xsl:value-of select="$FFPosConcept"/>
                                <br/>
                                ALLOWABLE ENTRIES: DECIMAL NUMBER<br/>
                                Min Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MinimumLength']"/><br/>
                                Max Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MaximumLength']"/><br/>
                                Min Decimal Places:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:appinfo/*[name()='MinimumDecimalPlaces']"/><br/>
                                Max Decimal Places:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:appinfo/*[name()='MaximumDecimalPlaces']"/><br/>
                                Range: (<xsl:value-of select="xsd:restriction[@base='xsd:decimal']/xsd:minInclusive/@value"/> through, <xsl:value-of select="xsd:restriction[@base='xsd:decimal']/xsd:maxInclusive/@value"/>).
                                <br/>
                              </xsl:when>
                              <xsl:otherwise>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">INVALID&amp;nbsp;</xsl:text>
                                  </span>
                              </xsl:otherwise>
                            </xsl:choose>
                          </span>                            
                        </p>
                      </td>
                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <span style='font-family:"Courier New"'>
                            <xsl:value-of select ='$FldDesc'/>
                            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                          </span>
                        </p>
                      </td>
                      <xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:when test="count(document($fRef)/xsd:schema/xsd:complexType[concat('f:', @name) = $fExtBase1]) > 0">
                    <xsl:for-each select="document($fRef)/xsd:schema/xsd:complexType[concat('f:', @name) = $fExtBase1]">
                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <span style='font-family:"Courier New"'>
                            <xsl:choose>
                              <xsl:when test="xsd:restriction[@base='xsd:string']/xsd:pattern">
                                <!--<a href="./UnderConstruction.htm">
                              <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudName']"/>
                            </a>
                            <br/>                                
                            <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudExplanation']"/>-->
                                <xsl:value-of select="$FFPosConcept"/>
                                <br/><br/>
                                ALLOWABLE ENTRIES: <span style="color:maroon">
                                  <xsl:value-of select="xsd:restriction/xsd:pattern/@value"/>
                                  <br/><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:documentation"/>
                                  <br/>
                                </span>
                              </xsl:when>
                              <xsl:when test="count(xsd:restriction[@base='xsd:string']/xsd:enumeration) = 1">
                                <xsl:value-of select="$FFPosConcept"/>
                                <br/><br/>
                                ALLOWABLE ENTRIES: <span style="color:maroon">
                                  <xsl:value-of select="xsd:restriction/xsd:enumeration/@value"/>
                                </span>
                                <br/>
                              </xsl:when>
                              <xsl:when test="count(xsd:restriction[@base='xsd:string']/xsd:enumeration)>1">
                                <xsl:variable name="fieldNameType" select="@name"/>
                                <xsl:value-of select="$FFPosConcept"/>
                                <br/>
                                Click <a href="javascript:GetEnumList('{$fieldNameType}', '{$fRef}')">here</a> for the list of allowable values.
                              </xsl:when>
                              <xsl:when test="xsd:restriction[@base='xsd:integer']/xsd:pattern">
                                <xsl:value-of select="$FFPosConcept"/>
                                <br/>
                                ALLOWABLE ENTRIES: INTEGER<br/>
                                Min Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MinimumLength']"/><br/>
                                Max Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MaximumLength']"/><br/>
                                Range: (<xsl:value-of select="xsd:restriction[@base='xsd:integer']/xsd:minInclusive/@value"/> through <xsl:value-of select="xsd:restriction[@base='xsd:integer']/xsd:maxInclusive/@value"/>).
                                <br/>
                              </xsl:when>
                              <xsl:when test="xsd:restriction[@base='xsd:decimal']/xsd:pattern">
                                <xsl:value-of select="$FFPosConcept"/>
                                <br/>
                                ALLOWABLE ENTRIES: DECIMAL NUMBER<br/>
                                Min Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MinimumLength']"/><br/>
                                Max Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MaximumLength']"/><br/>
                                Min Decimal Places:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:appinfo/*[name()='MinimumDecimalPlaces']"/><br/>
                                Max Decimal Places:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:appinfo/*[name()='MaximumDecimalPlaces']"/><br/>
                                Range: (<xsl:value-of select="xsd:restriction[@base='xsd:decimal']/xsd:minInclusive/@value"/> through, <xsl:value-of select="xsd:restriction[@base='xsd:decimal']/xsd:maxInclusive/@value"/>).
                                <br/>
                              </xsl:when>
                              <xsl:otherwise>
                                <span style='font-family:"Courier New"'>
                                  <xsl:text disable-output-escaping="yes">INVALID&amp;nbsp;</xsl:text>
                                </span>
                              </xsl:otherwise>
                            </xsl:choose>
                          </span>
                        </p>
                      </td>
                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <span style='font-family:"Courier New"'>
                            <xsl:value-of select ='$FldDesc'/>
                            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                          </span>
                        </p>
                      </td>
                      <xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
                    </xsl:for-each>
                  </xsl:when>
                </xsl:choose>  
              </xsl:when>
              <!---->
              <xsl:when test="xsd:complexType/xsd:complexContent/xsd:extension">
                <xsl:variable name="FldDesc" select="xsd:complexType/xsd:complexContent/xsd:extension/xsd:annotation/xsd:appinfo/*[name()='FieldDescriptor']" />
                <!--<xsl:variable name="Index">
                  <xsl:number format="A"/>
                </xsl:variable>-->
                <xsl:call-template name="tFieldFormatPositionEntry">
                  <!-- This parameter passes the position number of the field format position -->
                  <xsl:with-param name="FFPosNumber" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionNumber']"/>
                  <!-- This parameter specifies the occurrence category of the Field Format position -->
                  <xsl:with-param name="OccurrenceCategory" select="xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']"/>
                  <!-- This parameter specifies the name of the Field Format position -->
                  <xsl:with-param name="FFPosName" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionName']"/>
                </xsl:call-template>  
                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                  <p class='MsoNormal'>
                    <span style='font-family:"Courier New"'>
                      <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionConcept']"/>
                    </span>
                  </p>
                </td>
                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                  <p class='MsoNormal'>
                    <span style='font-family:"Courier New"'>
                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                    </span>
                  </p>
                </td>
                <xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
                <xsl:variable name="cExtBase1" select="xsd:complexType/xsd:complexContent/xsd:extension/@base"/>
                <xsl:for-each select="document($cRef)/xsd:schema/xsd:complexType[concat('c:', @name) = $cExtBase1]">
                    <tr style='height:37.5pt'>
                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <span style='font-family:"Courier New"'>
                            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                          </span>
                        </p>
                      </td>
                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <span style='font-family:"Courier New"'>
                            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                          </span>
                        </p>
                      </td>
                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <span style='font-family:"Courier New"'>
                            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                          </span>
                        </p>
                      </td>
                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <!--<span style='font-family:"Courier New"'>
                            <xsl:value-of select="concat($Index,'. ')"/>
                          </span>-->
                          <span style='font-family:"Courier New";color:green'>
                            <u><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudName']"/>
                            </u>
                          </span>
                          <br/>
                          <span style='font-family:"Courier New"'>EXPRESSED AS FOLLOWS:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                          </span>
                        </p>
                      </td>
                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <span style='font-family:"Courier New"'>
                            <xsl:value-of select='$FldDesc'/>
                            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                          </span>
                        </p>
                      </td>
                    </tr>
                    <!--  From the composites.xsd document, get the type of each element contains in the composite field then using it to retrieve
                          the Fud names in the Fields.xsd -->
                    <xsl:for-each select="xsd:sequence/xsd:element">
                      <xsl:variable name="curfBase" select="@type"/>
                      <xsl:for-each select="document($fRef)/xsd:schema/xsd:simpleType[concat('f:', @name) = $curfBase]">
                          <tr style='height:37.5pt'>
                            <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                              <p class='MsoNormal'>
                                <span style='font-family:"Courier New"'>
                                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                </span>
                              </p>
                            </td>
                            <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                              <p class='MsoNormal'>
                                <span style='font-family:"Courier New"'>
                                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                </span>
                              </p>
                            </td>
                            <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                              <p class='MsoNormal'>
                                <span style='font-family:"Courier New"'>
                                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                </span>
                              </p>
                            </td>
                            <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                              <xsl:call-template name='tFieldExplanation'>
                                <xsl:with-param name='tabSize' select='5'/>
                              </xsl:call-template>
                            </td>
                            <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                              <p class='MsoNormal'>
                                <span style='font-family:"Courier New"'>
                                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                </span>
                              </p>
                            </td>
                          </tr>
                      </xsl:for-each>
                    </xsl:for-each>     
                </xsl:for-each>
              </xsl:when>
              <!---->
              <xsl:when test="xsd:complexType/xsd:choice/xsd:element">
                <xsl:call-template name="tFieldFormatPositionEntry">
                  <!-- This parameter passes the position number of the field format position -->
                  <xsl:with-param name="FFPosNumber" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionNumber']"/>
                  <!-- This parameter specifies the occurrence category of the Field Format position -->
                  <xsl:with-param name="OccurrenceCategory" select="xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']"/>
                  <!-- This parameter specifies the name of the Field Format position -->
                  <xsl:with-param name="FFPosName" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionName']"/>
                </xsl:call-template>
                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                  <p class='MsoNormal'>
                    <span style='font-family:"Courier New"'>
                      <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionConcept']"/>
                    </span>
                  </p>
                </td>
                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                  <p class='MsoNormal'>
                    <span style='font-family:"Courier New"'>
                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                    </span>
                  </p>
                </td>
                <xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
                
                <xsl:for-each select="xsd:complexType/xsd:choice/xsd:element">
                  <xsl:choose>
                    <xsl:when test="xsd:complexType/xsd:simpleContent/xsd:extension">
                      <xsl:variable name="FldDesc" select="xsd:annotation/xsd:appinfo/*[name()='FieldDescriptor']"/>
                      <xsl:variable name="Index">
                        <xsl:number format="A"/>
                      </xsl:variable>
                      <xsl:variable name="fExtBase2" select="xsd:complexType/xsd:simpleContent/xsd:extension/@base"/>
                      <xsl:choose>
                        <xsl:when test="count(document($fRef)/xsd:schema/xsd:simpleType[concat('f:', @name) = $fExtBase2]) > 0">

                          <xsl:for-each select="document($fRef)/xsd:schema/xsd:simpleType[concat('f:', @name) = $fExtBase2]">
                            <tr style='height:37.5pt'>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <xsl:call-template name='tFieldExplanation'>
                                  <xsl:with-param name='tabSize' select='0'/>
                                  <xsl:with-param name='iIndex' select ='$Index'/>
                                </xsl:call-template>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:value-of select="$FldDesc"/>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                            </tr>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="count(document($fRef)/xsd:schema/xsd:complexType[concat('f:', @name) = $fExtBase2]) > 0">
                          <xsl:for-each select="document($fRef)/xsd:schema/xsd:complexType[concat('f:', @name) = $fExtBase2]">
                            <tr style='height:37.5pt'>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <xsl:call-template name='tFieldExplanation'>
                                  <xsl:with-param name='tabSize' select='0'/>
                                  <xsl:with-param name='iIndex' select ='$Index'/>
                                </xsl:call-template>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:value-of select="$FldDesc"/>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                            </tr>
                          </xsl:for-each>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:when test="xsd:complexType/xsd:complexContent/xsd:extension">
                      <xsl:variable name="FldDesc" select="xsd:annotation/xsd:appinfo/*[name()='FieldDescriptor']"/>
                      <xsl:variable name="Index">
                        <xsl:number format="A"/>
                      </xsl:variable>
                      <!-- added FFirnN and FudN variable 3-25-2010 by Jeff King -->
                      <xsl:variable name="FFirnN" select="substring-before(substring(xsd:complexType/xsd:complexContent/xsd:extension/xsd:attribute/@fixed, 3), '-')"/>
                      <xsl:variable name="FudN" select="substring-after(substring(xsd:complexType/xsd:complexContent/xsd:extension/xsd:attribute/@fixed,3), '-')"/>
                      
                      <xsl:variable name="cExtBase2" select="xsd:complexType/xsd:complexContent/xsd:extension/@base"/>
                      <xsl:for-each select="document($cRef)/xsd:schema/xsd:complexType[concat('c:', @name) = $cExtBase2]">
                          <tr style='height:37.5pt'>
                            <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                              <p class='MsoNormal'>
                                <span style='font-family:"Courier New"'>
                                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                </span>
                              </p>
                            </td>
                            <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                              <p class='MsoNormal'>
                                <span style='font-family:"Courier New"'>
                                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                </span>
                              </p>
                            </td>
                            <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                              <p class='MsoNormal'>
                                <span style='font-family:"Courier New"'>
                                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                </span>
                              </p>
                            </td>
                            <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                              <p class='MsoNormal'>
                                <span style='font-family:"Courier New"'>
                                <xsl:value-of select="concat(string($Index), '. ')"/>
                                </span>
                                <span style='font-family:"Courier New";color:green'>
                                  <u>   <!-- added perdicate to appinfo 3-25-2010 by Jeff King -->
                                    <xsl:value-of select="xsd:annotation/xsd:appinfo[*[name()='FudNumber']=$FudN and 
                                    *[name()='FieldFormatIndexReferenceNumber']=$FFirnN]/*[name()='FudName']"/>
                                  </u>
                                </span>
                                <br/>
                                <br/>
                                <span style='font-family:"Courier New"'><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudExplanation']"/>
                                </span>
                                <br/>
                                <span style='font-family:"Courier New"'>
                                  EXPRESS AS FOLLOWS:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                </span>
                              </p>
                            </td>
                            <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                              <p class='MsoNormal'>
                                <span style='font-family:"Courier New"'>
                                  <xsl:value-of select="$FldDesc"/>
                                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                </span>
                              </p>
                            </td>
                          </tr>
                          <!--  From the composites.xsd document, get the type of each element contains in the composite field then using it to retrieve
                                the Fud names in the Fields.xsd -->
                          <xsl:for-each select="xsd:sequence/xsd:element">
                            <xsl:variable name="curfBase" select="@type"/>
                            <xsl:for-each select="document($fRef)/xsd:schema/xsd:simpleType[concat('f:', @name) = $curfBase]">
                                <tr style='height:37.5pt'>
                                  <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                    <p class='MsoNormal'>
                                      <span style='font-family:"Courier New"'>
                                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                      </span>
                                    </p>
                                  </td>
                                  <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                    <p class='MsoNormal'>
                                      <span style='font-family:"Courier New"'>
                                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                      </span>
                                    </p>
                                  </td>
                                  <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                    <p class='MsoNormal'>
                                      <span style='font-family:"Courier New"'>
                                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                      </span>
                                    </p>
                                  </td>
                                  <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                    <xsl:call-template name='tFieldExplanation'>
                                      <xsl:with-param name='tabSize' select='5'/>
                                    </xsl:call-template>
                                  </td>
                                  <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                    <p class='MsoNormal'>
                                      <span style='font-family:"Courier New"'>
                                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                      </span>
                                    </p>
                                  </td>
                                </tr>
                            </xsl:for-each>
                          </xsl:for-each>
                      </xsl:for-each>
                    </xsl:when>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:when>
                
              <!--If GroupOfFields-->
              <xsl:when test="xsd:complexType/xsd:sequence/xsd:element">
                <xsl:for-each select="xsd:complexType/xsd:sequence/xsd:element">
                  <xsl:choose>
                    <xsl:when test="xsd:complexType/xsd:simpleContent/xsd:extension">
                      <xsl:variable name="FldDesc" select="xsd:annotation/xsd:appinfo/*[name()='FieldDescriptor']"/>
                      <xsl:call-template name="tFieldFormatPositionEntry">
                        <!-- This parameter passes the position number of the field format position -->
                        <xsl:with-param name="FFPosNumber" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionNumber']"/>
                        <!-- This parameter specifies the occurrence category of the Field Format position -->
                        <xsl:with-param name="OccurrenceCategory" select="concat(xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory'], ', R')"/>
                        <!-- This parameter specifies the name of the Field Format position -->
                        <xsl:with-param name="FFPosName" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionName']"/>
                      </xsl:call-template>
                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <span style='font-family:"Courier New"'>
                            <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionConcept']"/>
                          </span>
                        </p>
                      </td>
                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <span style='font-family:"Courier New"'>
                            <xsl:value-of select="$FldDesc"/>
                            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                          </span>
                        </p>
                      </td>
                      <xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>

                      <xsl:variable name="fExtBase3" select="xsd:complexType/xsd:simpleContent/xsd:extension/@base"/>
                      <xsl:for-each select="document($fRef)/xsd:schema/xsd:simpleType[concat('f:', @name) = $fExtBase3]">
                        <tr style='height:37.5pt'>
                          <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                            <p class='MsoNormal'>
                              <span style='font-family:"Courier New"'>
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                              </span>
                            </p>
                          </td>
                          <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                            <p class='MsoNormal'>
                              <span style='font-family:"Courier New"'>
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                              </span>
                            </p>
                          </td>
                          <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                            <p class='MsoNormal'>
                              <span style='font-family:"Courier New"'>
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                              </span>
                            </p>
                          </td>
                          <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                            <xsl:call-template name='tFieldExplanation'>
                              <xsl:with-param name='tabSize' select='5'/>
                            </xsl:call-template>
                          </td>
                          <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                            <p class='MsoNormal'>
                              <span style='font-family:"Courier New"'>
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                              </span>
                            </p>
                          </td>
                        </tr>
                      </xsl:for-each>
                      
                    </xsl:when>
                    <xsl:when test="xsd:complexType/xsd:complexContent/xsd:extension">
                      <!--<xsl:variable name="Index">
                        <xsl:number format="A"/>
                      </xsl:variable>-->
                      <xsl:variable name="FldDesc" select="xsd:annotation/xsd:appinfo/*[name()='FieldDescriptor']"/>
                      <xsl:call-template name="tFieldFormatPositionEntry">
                        <!-- This parameter passes the position number of the field format position -->
                        <xsl:with-param name="FFPosNumber" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionNumber']"/>
                        <!-- This parameter specifies the occurrence category of the Field Format position -->
                        <xsl:with-param name="OccurrenceCategory" select="concat(xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory'], ', R')"/>
                        <!-- This parameter specifies the name of the Field Format position -->
                        <xsl:with-param name="FFPosName" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionName']"/>
                      </xsl:call-template>
                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <span style='font-family:"Courier New"'>
                            <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionConcept']"/>
                          </span>
                        </p>
                      </td>
                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <span style='font-family:"Courier New"'>
                            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                            <!--<xsl:value-of select="$FldDesc"/>-->
                          </span>
                        </p>
                      </td>
                      <xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
                      
                      <xsl:variable name="cExtBase3" select="xsd:complexType/xsd:complexContent/xsd:extension/@base"/>
                      <xsl:for-each select="document($cRef)/xsd:schema/xsd:complexType[concat('c:', @name) = $cExtBase3]">
                        <tr style='height:37.5pt'>
                          <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                            <p class='MsoNormal'>
                              <span style='font-family:"Courier New"'>
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                              </span>
                            </p>
                          </td>
                          <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                            <p class='MsoNormal'>
                              <span style='font-family:"Courier New"'>
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                              </span>
                            </p>
                          </td>
                          <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                            <p class='MsoNormal'>
                              <span style='font-family:"Courier New"'>
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                              </span>
                            </p>
                          </td>
                          <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                            <p class='MsoNormal'>
                              <!--<span style='font-family:"Courier New"'>
                                <xsl:value-of select="concat($Index, '. ')"/>
                              </span>-->
                              <span style='font-family:"Courier New";color:green'>
                                <u>
                                  <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudName']"/>
                                </u>
                              </span>
                              <br/>
                              <br/>
                              <span style='font-family:"Courier New"'>
                                <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudExplanation']"/>
                              </span>
                              <br/>
                              <span style='font-family:"Courier New"'>
                                EXPRESS AS FOLLOWS:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                              </span>
                            </p>
                          </td>
                          <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                            <p class='MsoNormal'>
                              <span style='font-family:"Courier New"'>
                                <xsl:value-of select="$FldDesc"/>
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                              </span>
                            </p>
                          </td>
                        </tr>
                        <!--  From the composites.xsd document, get the type of each element contains in the composite field then using it to retrieve
                                the Fud names in the Fields.xsd -->
                        <xsl:for-each select="xsd:sequence/xsd:element">
                          <xsl:variable name="curfBase" select="@type"/>
                          <xsl:for-each select="document($fRef)/xsd:schema/xsd:simpleType[concat('f:', @name) = $curfBase]">
                            <tr style='height:37.5pt'>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <xsl:call-template name='tFieldExplanation'></xsl:call-template>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                            </tr>
                          </xsl:for-each>
                        </xsl:for-each>
                      </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="xsd:complexType/xsd:choice/xsd:element">
                      <xsl:call-template name="tFieldFormatPositionEntry">
                        <xsl:with-param name="FFPosNumber" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionNumber']"/>
                        <xsl:with-param name="OccurrenceCategory" select="concat(xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory'], ', R')"/>
                        <xsl:with-param name="FFPosName" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionName']"/>
                      </xsl:call-template>

                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <span style='font-family:"Courier New"'>
                            <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionConcept']"/>
                          </span>
                          <br/>
                          <span style='font-family:"Courier New"; color:red'>
                          </span>
                        </p>
                      </td>
                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <span style='font-family:"Courier New"'>
                            <!--<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>-->
                            Choice of <xsl:value-of select="count(xsd:complexType/xsd:choice/xsd:element)"/> elements as follow:
                          </span>
                        </p>
                      </td>
                      <xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
                      
                      <xsl:for-each select="xsd:complexType/xsd:choice/xsd:element">
                        <xsl:choose>
                          <xsl:when test="xsd:complexType/xsd:simpleContent/xsd:extension">
                            <xsl:variable name="FldDesc" select="xsd:annotation/xsd:appinfo/*[name()='FieldDescriptor']"/>
                            <xsl:variable name="Index">
                              <xsl:number format="A"/>
                            </xsl:variable>
                            <xsl:variable name="fExtBase4" select="xsd:complexType/xsd:simpleContent/xsd:extension/@base"/>
                            <xsl:for-each select="document($fRef)/xsd:schema/xsd:simpleType[concat('f:', @name) = $fExtBase4]">
                              <tr style='height:37.5pt'>
                                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                  <p class='MsoNormal'>
                                    <span style='font-family:"Courier New"'>
                                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                    </span>
                                  </p>
                                </td>
                                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                  <p class='MsoNormal'>
                                    <span style='font-family:"Courier New"'>
                                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                    </span>
                                  </p>
                                </td>
                                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                  <p class='MsoNormal'>
                                    <span style='font-family:"Courier New"'>
                                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                    </span>
                                  </p>
                                </td>
                                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                  <xsl:call-template name='tFieldExplanation'>
                                    <xsl:with-param name='tabSize' select='0'/>
                                    <xsl:with-param name ='iIndex' select='$Index'/>
                                  </xsl:call-template>
                                </td>
                                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                  <p class='MsoNormal'>
                                    <span style='font-family:"Courier New"'>
                                      <xsl:value-of select="$FldDesc"/>
                                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                    </span>
                                  </p>
                                </td>
                              </tr>
                            </xsl:for-each>
                          </xsl:when>

                          <xsl:when test="xsd:complexType/xsd:complexContent/xsd:extension">
                            <xsl:variable name="FldDesc" select="xsd:annotation/xsd:appinfo/*[name()='FieldDescriptor']"/>
                            <xsl:variable name="Index">
                              <xsl:number format="A"/>
                            </xsl:variable>
                            <xsl:variable name="cExtBase4" select="xsd:complexType/xsd:complexContent/xsd:extension/@base"/>
                            <!-- added FFirnN and FudN variable 3-25-2010 by Jeff King -->
                            <xsl:variable name="FFirnN" select="substring-before(substring(xsd:complexType/xsd:complexContent/xsd:extension/xsd:attribute/@fixed, 3), '-')"/>
							<xsl:variable name="FudN" select="substring-after(substring(xsd:complexType/xsd:complexContent/xsd:extension/xsd:attribute/@fixed,3), '-')"/>

                            <xsl:for-each select="document($cRef)/xsd:schema/xsd:complexType[concat('c:', @name) = $cExtBase4]">
                              <tr style='height:37.5pt'>
                                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                  <p class='MsoNormal'>
                                    <span style='font-family:"Courier New"'>
                                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                    </span>
                                  </p>
                                </td>
                                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                  <p class='MsoNormal'>
                                    <span style='font-family:"Courier New"'>
                                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                    </span>
                                  </p>
                                </td>
                                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                  <p class='MsoNormal'>
                                    <span style='font-family:"Courier New"'>
                                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                    </span>
                                  </p>
                                </td>
                                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                  <p class='MsoNormal'>
                                    <span style='font-family:"Courier New"'>
                                      <xsl:value-of select="concat($Index, '. ')"/>
                                    </span>
                                    <span style='font-family:"Courier New";color:green'>
                                      <u>
                                    <xsl:value-of select="xsd:annotation/xsd:appinfo[*[name()='FudNumber']=$FudN and 
                                    *[name()='FieldFormatIndexReferenceNumber']=$FFirnN]/*[name()='FudName']"/>
                                      </u>
                                    </span>
                                    <br/>
                                    <br/>
                                    <span style='font-family:"Courier New"'>
                                      <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudExplanation']"/>
                                    </span>
                                    <br/>
                                    <span style='font-family:"Courier New"'>
                                      EXPRESS AS FOLLOWS:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                    </span>
                                  </p>
                                </td>
                                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                  <p class='MsoNormal'>
                                    <span style='font-family:"Courier New"'>
                                      <xsl:value-of select="$FldDesc"/>
                                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                    </span>
                                  </p>
                                </td>
                              </tr>
                              <!--  From the composites.xsd document, get the type of each element contains in the composite field then using it to retrieve
                                      the Fud names in the Fields.xsd -->
                              <xsl:for-each select="xsd:sequence/xsd:element">
                                <xsl:variable name="curfBase" select="@type"/>
                                <xsl:for-each select="document($fRef)/xsd:schema/xsd:simpleType[concat('f:', @name) = $curfBase]">
                                  <tr style='height:37.5pt'>
                                    <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                      <p class='MsoNormal'>
                                        <span style='font-family:"Courier New"'>
                                          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                        </span>
                                      </p>
                                    </td>
                                    <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                      <p class='MsoNormal'>
                                        <span style='font-family:"Courier New"'>
                                          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                        </span>
                                      </p>
                                    </td>
                                    <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                      <p class='MsoNormal'>
                                        <span style='font-family:"Courier New"'>
                                          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                        </span>
                                      </p>
                                    </td>
                                    <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                      <xsl:call-template name='tFieldExplanation'>
                                        <xsl:with-param name='tabSize' select='5'/>
                                      </xsl:call-template>
                                    </td>
                                    <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                      <p class='MsoNormal'>
                                        <span style='font-family:"Courier New"'>
                                          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                        </span>
                                      </p>
                                    </td>
                                  </tr>
                                </xsl:for-each>
                              </xsl:for-each>
                            </xsl:for-each>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:call-template name="tDebugEntry">
                              <xsl:with-param name="FDebugInfo" select="'INVALID!'"/>
                            </xsl:call-template>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:for-each>
                    </xsl:when>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*[name()='SetFormatIdentifier']=$selectedSetid]/xsd:sequence/xsd:element">
          <!--<xsl:call-template name="tDebugEntry">
            <xsl:with-param name="FDebugInfo" select="count(/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*[name()='SetFormatIdentifier']=$selectedSetid]/xsd:sequence/xsd:element)"/>
          </xsl:call-template>-->
          <xsl:for-each select="/xsd:schema/xsd:complexType[xsd:annotation/xsd:appinfo/*[name()='SetFormatIdentifier']=$selectedSetid]/xsd:sequence/xsd:element">
            <xsl:variable name="FFPosConcept" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionConcept']"/>
            <xsl:variable name="fbase" select="concat('f:', @name, 'Type')"/>
            <xsl:variable name="cbase" select="concat('c:', @name, 'Type')"/>
            <xsl:variable name="fRef" select="concat($folderString, '/fields.xsd')"/>
            <xsl:variable name="cRef" select="concat($folderString, '/composites.xsd')"/>

            <xsl:choose>
              <xsl:when test="xsd:complexType/xsd:simpleContent/xsd:extension">
                <xsl:variable name="FldDesc" select="xsd:annotation/xsd:appinfo/*[name()='FieldDescriptor']" />
                <xsl:call-template name="tFieldFormatPositionEntry">
                  <!-- This parameter passes the position number of the field format position -->
                  <xsl:with-param name="FFPosNumber" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionNumber']"/>
                  <!-- This parameter specifies the occurrence category of the Field Format position -->
                  <xsl:with-param name="OccurrenceCategory" select="xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']"/>
                  <!-- This parameter specifies the name of the Field Format position -->
                  <xsl:with-param name="FFPosName" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionName']"/>
                </xsl:call-template>
                <xsl:variable name="fExtBase1" select="xsd:complexType/xsd:simpleContent/xsd:extension/@base"/>
                <xsl:choose>
                  <xsl:when test="count(document($fRef)/xsd:schema/xsd:simpleType[concat('f:', @name) = $fExtBase1])> 0">
                    <xsl:for-each select="document($fRef)/xsd:schema/xsd:simpleType[concat('f:', @name) = $fExtBase1]">
                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <span style='font-family:"Courier New"'>
                            <xsl:choose>
                              <xsl:when test="xsd:restriction[@base='xsd:string']/xsd:pattern">
                                <!--<a href="./UnderConstruction.htm">
                                <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudName']"/>
                              </a>
                              <br/>                                
                              <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudExplanation']"/>-->
                                <xsl:value-of select="$FFPosConcept"/>
                                <br/><br/>
                                ALLOWABLE ENTRIES: <span style="color:maroon">
                                  <xsl:value-of select="xsd:restriction/xsd:pattern/@value"/>
                                  <br/><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:documentation"/>
                                  <br/>
                                </span>
                              </xsl:when>
                              <xsl:when test="count(xsd:restriction[@base='xsd:string']/xsd:enumeration) = 1">
                                <xsl:value-of select="$FFPosConcept"/>
                                <br/><br/>
                                ALLOWABLE ENTRIES: <span style="color:maroon">
                                  <xsl:value-of select="xsd:restriction/xsd:enumeration/@value"/>
                                </span>
                                <br/>
                              </xsl:when>
                              <xsl:when test="count(xsd:restriction[@base='xsd:string']/xsd:enumeration)>1">
                                <xsl:variable name="fieldNameType" select="@name"/>
                                <xsl:value-of select="$FFPosConcept"/>
                                <br/>
                                Click <a href="javascript:GetEnumList('{$fieldNameType}', '{$fRef}')">here</a> for the list of allowable values.
                              </xsl:when>
                              <xsl:when test="xsd:restriction[@base='xsd:integer']/xsd:pattern">
                                <xsl:value-of select="$FFPosConcept"/>
                                <br/>
                                ALLOWABLE ENTRIES: INTEGER
                                Min Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MinimumLength']"/><br/>
                                Max Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MaximumLength']"/><br/>
                                Range: (<xsl:value-of select="xsd:restriction[@base='xsd:integer']/xsd:minInclusive/@value"/> through <xsl:value-of select="xsd:restriction[@base='xsd:integer']/xsd:maxInclusive/@value"/>).
                                <br/>
                              </xsl:when>
                              <xsl:when test="xsd:restriction[@base='xsd:decimal']/xsd:pattern">
                                <xsl:value-of select="$FFPosConcept"/>
                                <br/>
                                ALLOWABLE ENTRIES: DECIMAL NUMBER
                                Min Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MinimumLength']"/><br/>
                                Max Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MaximumLength']"/><br/>
                                Min Decimal Places:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:appinfo/*[name()='MinimumDecimalPlaces']"/><br/>
                                Max Decimal Places:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:appinfo/*[name()='MaximumDecimalPlaces']"/><br/>
                                Range: (<xsl:value-of select="xsd:restriction[@base='xsd:decimal']/xsd:minInclusive/@value"/> through <xsl:value-of select="xsd:restriction[@base='xsd:decimal']/xsd:maxInclusive/@value"/>).
                                <br/>
                              </xsl:when>
                              <xsl:otherwise>
                                <span style='font-family:"Courier New"'>
                                  <xsl:text disable-output-escaping="yes">INVALID&amp;nbsp;</xsl:text>
                                </span>
                              </xsl:otherwise>
                            </xsl:choose>
                          </span>
                        </p>
                      </td>
                      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                        <p class='MsoNormal'>
                          <span style='font-family:"Courier New"'>
                            <xsl:value-of select ='$FldDesc'/>
                            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                          </span>
                        </p>
                      </td>
                      <xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
                    </xsl:for-each>
                  </xsl:when>
                  
                  <xsl:when test="count(document($fRef)/xsd:schema/xsd:complexType[concat('f:', @name) = $fExtBase1])> 0">
                    <xsl:for-each select="document($fRef)/xsd:schema/xsd:complexType[concat('f:', @name) = $fExtBase1]">
                      
                      <xsl:variable name="fBaseType" select="xsd:simpleContent/xsd:extension/@base"/>
                      <xsl:for-each select="/xsd:schema/xsd:simpleType[@name=$fBaseType]">
                        <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                          <p class='MsoNormal'>
                            <span style='font-family:"Courier New"'>
                              <xsl:choose>
                                <xsl:when test="xsd:restriction[@base='xsd:string']/xsd:pattern">
                                  <!--<a href="./UnderConstruction.htm">
                                  <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudName']"/>
                                </a>
                                <br/>                                
                                <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudExplanation']"/>-->
                                  <xsl:value-of select="$FFPosConcept"/>
                                  <br/><br/>
                                  ALLOWABLE ENTRIES: <span style="color:maroon">
                                    <xsl:value-of select="xsd:restriction/xsd:pattern/@value"/>
                                    <br/>><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:documentation"/>
                                    <br/>
                                  </span>
                                </xsl:when>
                                <xsl:when test="count(xsd:restriction[@base='xsd:string']/xsd:enumeration) = 1">
                                  <xsl:value-of select="$FFPosConcept"/>
                                  <br/><br/>
                                  ALLOWABLE ENTRIES: <span style="color:maroon">
                                    <xsl:value-of select="xsd:restriction/xsd:enumeration/@value"/>
                                  </span>
                                  <br/>
                                </xsl:when>
                                <xsl:when test="count(xsd:restriction[@base='xsd:string']/xsd:enumeration)>1">
                                  <xsl:variable name="fieldNameType" select="@name"/>
                                  <xsl:value-of select="$FFPosConcept"/>
                                  <br/>
                                  Click <a href="javascript:GetEnumList('{$fieldNameType}', '{$fRef}')">here</a> for the list of allowable values.
                                </xsl:when>
                                <xsl:when test="xsd:restriction[@base='xsd:integer']/xsd:pattern">
                                  <xsl:value-of select="$FFPosConcept"/>
                                  <br/>
                                  ALLOWABLE ENTRIES: INTEGER<br/>
                                  Min Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MinimumLength']"/><br/>
                                  Max Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MaximumLength']"/><br/>
                                  Range: (<xsl:value-of select="xsd:restriction[@base='xsd:integer']/xsd:minInclusive/@value"/> through <xsl:value-of select="xsd:restriction[@base='xsd:integer']/xsd:maxInclusive/@value"/>).
                                  <br/>
                                </xsl:when>
                                <xsl:when test="xsd:restriction[@base='xsd:decimal']/xsd:pattern">
                                  <xsl:value-of select="$FFPosConcept"/>
                                  <br/>
                                  ALLOWABLE ENTRIES: DECIMAL NUMBER<br/>
                                  Min Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MinimumLength']"/><br/>
                                  Max Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MaximumLength']"/><br/>
                                  Min Decimal Places:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:appinfo/*[name()='MinimumDecimalPlaces']"/><br/>
                                  Max Decimal Places:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:appinfo/*[name()='MaximumDecimalPlaces']"/><br/>
                                  Range: (<xsl:value-of select="xsd:restriction[@base='xsd:decimal']/xsd:minInclusive/@value"/> through <xsl:value-of select="xsd:restriction[@base='xsd:decimal']/xsd:maxInclusive/@value"/>).
                                  <br/>
                                </xsl:when>
                                <xsl:otherwise>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">INVALID&amp;nbsp;</xsl:text>
                                  </span>
                                </xsl:otherwise>
                              </xsl:choose>
                            </span>
                          </p>
                        </td>
                        <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                          <p class='MsoNormal'>
                            <span style='font-family:"Courier New"'>
                              <xsl:value-of select ='$FldDesc'/>
                              <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                            </span>
                          </p>
                        </td>
                        <xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
                      </xsl:for-each>
                    </xsl:for-each>
                  </xsl:when>
                </xsl:choose>  
              </xsl:when>
              <!---->
              <xsl:when test="xsd:complexType/xsd:complexContent/xsd:extension">
                <xsl:variable name="FldDesc" select="xsd:annotation/xsd:appinfo/*[name()='FieldDescriptor']" />
                <xsl:call-template name="tFieldFormatPositionEntry">
                  <!-- This parameter passes the position number of the field format position -->
                  <xsl:with-param name="FFPosNumber" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionNumber']"/>
                  <!-- This parameter specifies the occurrence category of the Field Format position -->
                  <xsl:with-param name="OccurrenceCategory" select="xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']"/>
                  <!-- This parameter specifies the name of the Field Format position -->
                  <xsl:with-param name="FFPosName" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionName']"/>
                </xsl:call-template>
                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                  <p class='MsoNormal'>
                    <span style='font-family:"Courier New"'>
                      <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionConcept']"/>
                    </span>
                  </p>
                </td>
                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                  <p class='MsoNormal'>
                    <span style='font-family:"Courier New"'>
                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                    </span>
                  </p>
                </td>
                <xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
                
                <xsl:variable name="cExtBase1" select="xsd:complexType/xsd:complexContent/xsd:extension/@base"/>
                <xsl:for-each select="document($cRef)/xsd:schema/xsd:complexType[concat('c:', @name) = $cExtBase1]">
                  <tr style='height:37.5pt'>
                    <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                      <p class='MsoNormal'>
                        <span style='font-family:"Courier New"'>
                          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                        </span>
                      </p>
                    </td>
                    <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                      <p class='MsoNormal'>
                        <span style='font-family:"Courier New"'>
                          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                        </span>
                      </p>
                    </td>
                    <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                      <p class='MsoNormal'>
                        <span style='font-family:"Courier New"'>
                          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                        </span>
                      </p>
                    </td>
                    <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                      <p class='MsoNormal'>
                        <!--<span style='font-family:"Courier New"'>
                          <xsl:number format='A'/>
                        </span>-->
                        <span style='font-family:"Courier New";color:green'>
                          <u>
                            <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudName']"/>
                          </u>
                        </span>
                        <br/>
                        <span style='font-family:"Courier New"'>
                          EXPRESSED AS FOLLOWS:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                        </span>
                      </p>
                    </td>
                    <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                      <p class='MsoNormal'>
                        <span style='font-family:"Courier New"'>
                          <xsl:value-of select='$FldDesc'/>
                          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                        </span>
                      </p>
                    </td>
                  </tr>
                  <!--  From the composites.xsd document, get the type of each element contains in the composite field then using it to retrieve
                        the Fud names in the Fields.xsd -->
                  <xsl:for-each select="xsd:sequence/xsd:element">
                    <xsl:variable name="curfBase" select="@type"/>
                    <xsl:for-each select="document($fRef)/xsd:schema/xsd:simpleType[concat('f:', @name) = $curfBase]">
                      <tr style='height:37.5pt'>
                        <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                          <p class='MsoNormal'>
                            <span style='font-family:"Courier New"'>
                              <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                            </span>
                          </p>
                        </td>
                        <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                          <p class='MsoNormal'>
                            <span style='font-family:"Courier New"'>
                              <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                            </span>
                          </p>
                        </td>
                        <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                          <p class='MsoNormal'>
                            <span style='font-family:"Courier New"'>
                              <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                            </span>
                          </p>
                        </td>
                        <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                          <xsl:call-template name='tFieldExplanation'>
                            <xsl:with-param name='tabSize' select='5'/>
                          </xsl:call-template>
                        </td>
                        <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                          <p class='MsoNormal'>
                            <span style='font-family:"Courier New"'>
                              <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                            </span>
                          </p>
                        </td>
                      </tr>
                    </xsl:for-each>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:when>
              <!---->
              <xsl:when test="xsd:complexType/xsd:choice/xsd:element">
                <xsl:call-template name="tFieldFormatPositionEntry">
                  <!-- This parameter passes the position number of the field format position -->
                  <xsl:with-param name="FFPosNumber" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionNumber']"/>
                  <!-- This parameter specifies the occurrence category of the Field Format position -->
                  <xsl:with-param name="OccurrenceCategory" select="xsd:annotation/xsd:appinfo/*[name()='OccurrenceCategory']"/>
                  <!-- This parameter specifies the name of the Field Format position -->
                  <xsl:with-param name="FFPosName" select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionName']"/>
                </xsl:call-template>
                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                  <p class='MsoNormal'>
                    <span style='font-family:"Courier New"'>
                      <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FieldFormatPositionConcept']"/>
                    </span>
                  </p>
                </td>
                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                  <p class='MsoNormal'>
                    <span style='font-family:"Courier New"'>
                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                    </span>
                  </p>
                </td>
                <xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>

                <xsl:for-each select="xsd:complexType/xsd:choice/xsd:element">
                  <xsl:choose>
                    <xsl:when test="xsd:complexType/xsd:simpleContent/xsd:extension">
                      <xsl:variable name="FldDesc" select="xsd:annotation/xsd:appinfo/*[name()='FieldDescriptor']"/>
                      <xsl:variable name="Index">
                        <xsl:number format="A"/>
                      </xsl:variable>
                      <xsl:variable name="fExtBase2" select="xsd:complexType/xsd:simpleContent/xsd:extension/@base"/>
                      <xsl:choose>
                        <xsl:when test="count(document($fRef)/xsd:schema/xsd:simpleType[concat('f:', @name) = $fExtBase2])> 0">
                          <xsl:for-each select="document($fRef)/xsd:schema/xsd:simpleType[concat('f:', @name) = $fExtBase2]">
                            <tr style='height:37.5pt'>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <xsl:call-template name='tFieldExplanation'>
                                  <xsl:with-param name='tabSize' select='0'/>
                                  <xsl:with-param name='iIndex' select ='$Index'/>
                                </xsl:call-template>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:value-of select="$FldDesc"/>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                            </tr>
                          </xsl:for-each>
                        </xsl:when>
                        
                        <xsl:when test="count(document($fRef)/xsd:schema/xsd:complexType[concat('f:', @name) = $fExtBase2])> 0">
                          <xsl:for-each select="document($fRef)/xsd:schema/xsd:complexType[concat('f:', @name) = $fExtBase2]">
                            <xsl:variable name="fBaseType" select="xsd:simpleContent/xsd:extension/@base"/>
                            <xsl:for-each select="/xsd:schema/xsd:simpleType[@name=$fBaseType]">
                              <tr style='height:37.5pt'>
                                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                  <p class='MsoNormal'>
                                    <span style='font-family:"Courier New"'>
                                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                    </span>
                                  </p>
                                </td>
                                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                  <p class='MsoNormal'>
                                    <span style='font-family:"Courier New"'>
                                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                    </span>
                                  </p>
                                </td>
                                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                  <p class='MsoNormal'>
                                    <span style='font-family:"Courier New"'>
                                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                    </span>
                                  </p>
                                </td>
                                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                  <xsl:call-template name='tFieldExplanation'>
                                    <xsl:with-param name='tabSize' select='0'/>
                                    <xsl:with-param name='iIndex' select ='$Index'/>
                                  </xsl:call-template>
                                </td>
                                <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                  <p class='MsoNormal'>
                                    <span style='font-family:"Courier New"'>
                                      <xsl:value-of select="$FldDesc"/>
                                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                    </span>
                                  </p>
                                </td>
                              </tr>
                            </xsl:for-each>
                          </xsl:for-each>
                        </xsl:when>
                        
                      </xsl:choose>
                    </xsl:when>
                    <xsl:when test="xsd:complexType/xsd:complexContent/xsd:extension">
                      <xsl:variable name="FldDesc" select="xsd:annotation/xsd:appinfo/*[name()='FieldDescriptor']"/>
                      <xsl:variable name="Index">
                        <xsl:number format="A"/>
                      </xsl:variable>
                      <xsl:variable name="cExtBase2" select="xsd:complexType/xsd:complexContent/xsd:extension/@base"/>
                      <xsl:for-each select="document($cRef)/xsd:schema/xsd:complexType[concat('c:', @name) = $cExtBase2]">
                        <tr style='height:37.5pt'>
                          <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                            <p class='MsoNormal'>
                              <span style='font-family:"Courier New"'>
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                              </span>
                            </p>
                          </td>
                          <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                            <p class='MsoNormal'>
                              <span style='font-family:"Courier New"'>
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                              </span>
                            </p>
                          </td>
                          <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                            <p class='MsoNormal'>
                              <span style='font-family:"Courier New"'>
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                              </span>
                            </p>
                          </td>
                          <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                            <p class='MsoNormal'>
                              <span style='font-family:"Courier New"'>
                                <xsl:value-of select="concat(string($Index), '. ')"/>
                              </span>
                              <span style='font-family:"Courier New";color:green'>
                                <u>
                                  <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudName']"/>
                                </u>
                              </span>
                              <br/>
                              <br/>
                              <span style='font-family:"Courier New"'>
                                <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudExplanation']"/>
                              </span>
                              <br/>
                              <span style='font-family:"Courier New"'>
                                EXPRESS AS FOLLOWS:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                              </span>
                            </p>
                          </td>
                          <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                            <p class='MsoNormal'>
                              <span style='font-family:"Courier New"'>
                                <xsl:value-of select="$FldDesc"/>
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                              </span>
                            </p>
                          </td>
                        </tr>
                        <!--  From the composites.xsd document, get the type of each element contains in the composite field then using it to retrieve
                              the Fud names in the Fields.xsd -->
                        <xsl:for-each select="xsd:sequence/xsd:element">
                          <xsl:variable name="curfBase" select="@type"/>
                          <xsl:for-each select="document($fRef)/xsd:schema/xsd:simpleType[concat('f:', @name) = $curfBase]">
                            <tr style='height:37.5pt'>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <xsl:call-template name='tFieldExplanation'>
                                  <xsl:with-param name='tabSize' select='5'/>
                                </xsl:call-template>
                              </td>
                              <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                                <p class='MsoNormal'>
                                  <span style='font-family:"Courier New"'>
                                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                  </span>
                                </p>
                              </td>
                            </tr>
                          </xsl:for-each>
                        </xsl:for-each>
                      </xsl:for-each>
                    </xsl:when>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <tr style='height:37.5pt'>
                  <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                    <p class='MsoNormal'>
                      <span style='font-family:"Courier New"'>
                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                      </span>
                    </p>
                  </td>
                  <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                    <p class='MsoNormal'>
                      <span style='font-family:"Courier New"'>
                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                      </span>
                    </p>
                  </td>
                  <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                    <p class='MsoNormal'>
                      <span style='font-family:"Courier New"'>
                        <xsl:value-of select="@name"/>
                      </span>
                    </p>
                  </td>
                  <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                    <p class='MsoNormal'>
                      <span style='font-family:"Courier New"'>
                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                      </span>
                    </p>
                  </td>
                  <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
                    <p class='MsoNormal'>
                      <span style='font-family:"Courier New"'>
                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                      </span>
                    </p>
                  </td>
                </tr>
              </xsl:otherwise>
            </xsl:choose>  
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </table>
    <!--</div>-->
  </body>
  <!-- End Layout of Set Format -->
  </html>
  </xsl:template>
	<!-- End Template to Process Each Set -->

  <xsl:template name="tFieldFormatPositionEntry">
    <xsl:param name="FFPosNumber"/>
    <xsl:param name="OccurrenceCategory"/>
    <xsl:param name="FFPosName"/>
    <!--<xsl:param name="positionValue"/>-->
    <xsl:text disable-output-escaping="yes"><![CDATA[<tr style='height:37.5pt'>]]></xsl:text>
    <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
      <p class='MsoNormal'>
        <span style='font-family:"Courier New"'>
          <xsl:value-of select="$FFPosNumber"/>
        </span>
      </p>
    </td>
    <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
      <p class='MsoNormal' style="text-align:center;">
        <span style='font-family:"Courier New";'>
			<xsl:choose>
				<xsl:when test="substring($OccurrenceCategory, 1, 1)='M'">
				<!--b><font color="#FF0000">M</font></b>-->
				<b style="color:#FF0000">M</b>
</xsl:when>
				<xsl:when test="substring($OccurrenceCategory, 1, 1)='O'">
				<b style="color:#01DF01">O</b>
				</xsl:when>
				<xsl:when test="substring($OccurrenceCategory, 1, 1)='C'">
				<b style="color:#FE9A2E">C</b>
				</xsl:when>
        	</xsl:choose>
        	<xsl:if test="substring($OccurrenceCategory, string-length($OccurrenceCategory), 1) = 'R'">
        	<b>, R</b>
        	
        	</xsl:if>
          <!--<xsl:value-of select="$OccurrenceCategory"/>-->
        </span>
      </p>
    </td>
    <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
      <p class='MsoNormal'>
        <span style='font-family:"Courier New"'>
          <xsl:value-of select="$FFPosName"/>
        </span>
      </p>
    </td>

  </xsl:template>

  <xsl:template name="tDebugEntry">
    <xsl:param name="FDebugInfo"/>
    <tr style='height:37.5pt'>
      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
        <p class='MsoNormal'>
          <span style='font-family:"Courier New"'>
            ##
          </span>
        </p>
      </td>
      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
        <p class='MsoNormal'>
          <span style='font-family:"Courier New"'>
            X
          </span>
        </p>
      </td>
      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
        <p class='MsoNormal'>
          <span style='font-family:"Courier New"'>
            DBG INFO
          </span>
        </p>
      </td>
      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
        <p class='MsoNormal'>
          <span style='font-family:"Courier New"'>
            <xsl:value-of select="$FDebugInfo"/>
          </span>
        </p>
      </td>
      <td style='background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
        <p class='MsoNormal'>
          <span style='font-family:"Courier New"'>
            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
          </span>
        </p>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="tFieldExplanation">
    <xsl:param name="tabSize"/>
    <xsl:param name="iIndex"/>

    <xsl:variable name="FieldNameType" select="@name"/>
    <xsl:variable name="fPath" select="concat('./WithDoc/', $MsgId, '/fields.xsd')"/>
    <xsl:choose>
      <xsl:when test="$tabSize>0">
        <table width="100%" class='MsoNormalTable' border='0' cellpadding='0' cellspacing='0'>
          <tr style='height:37.5pt'>
            <td width="{$tabSize}%" style='width:{$tabSize}.0%;background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
              <p class='MsoNormal'>
                <span style='font-family:"Courier New"'>
                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </span>
              </p>
            </td>
            <td width="{100-$tabSize}%" style='width:{100-$tabSize}.0%;background:#FFFFF0;padding:.75pt .75pt .75pt .75pt;height:37.5pt'>
              <p class='MsoNormal'>
                <span style='font-family:"Courier New"'>
                  <!--<a href='./UnderConstruction.htm'>-->
                  <u><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudName']"/>
                  </u>
                  <!--</a>-->
                  <br/>
                  <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudExplanation']"/>
                  <br/>
                  <br/>
                  <xsl:choose>
                    <xsl:when test="xsd:restriction[@base='xsd:string']/xsd:pattern">
                      ALLOWABLE ENTRIES:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><span style="color:maroon">
                        <xsl:value-of select="xsd:restriction/xsd:pattern/@value"/>
                        <br/><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:documentation"/>
                      </span><br/><br/>
                    </xsl:when>
                    <xsl:when test="count(xsd:restriction[@base='xsd:string']/xsd:enumeration) > 1">
                      ALLOWABLE ENTRIES: Click <a href="javascript:GetEnumList('{$FieldNameType}', '{$fPath}')">here</a> for the list of allowable values.<br/>
                    </xsl:when>
                    <xsl:when test="count(xsd:restriction[@base='xsd:string']/xsd:enumeration) = 1">
                      ALLOWABLE ENTRIES: <span style="color:maroon">
                        <xsl:value-of select="xsd:restriction/xsd:enumeration/@value"/>
                      </span>
                      <br/><br/>
                    </xsl:when>
                    <xsl:when test="xsd:restriction[@base='xsd:integer']/xsd:pattern">
                      <!--<xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudName']"/>-->
                      <br/>
                      ALLOWABLE ENTRIES: INTEGER<br/>
                      Min Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MinimumLength']"/><br/>
                      Max Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MaximumLength']"/><br/>
                      Range: (<xsl:value-of select="xsd:restriction[@base='xsd:integer']/xsd:minInclusive/@value"/> through <xsl:value-of select="xsd:restriction[@base='xsd:integer']/xsd:maxInclusive/@value"/>).
                      <br/>
                    </xsl:when>
                    <xsl:when test="xsd:restriction[@base='xsd:decimal']/xsd:pattern">
                      ALLOWABLE ENTRIES: DECIMAL NUMBER<br/>
                      Min Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MinimumLength']"/><br/>
                      Max Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MaximumLength']"/><br/>
                      Min Decimal Places:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:appinfo/*[name()='MinimumDecimalPlaces']"/><br/>
                      Max Decimal Places:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:appinfo/*[name()='MaximumDecimalPlaces']"/><br/>
                      Range: (<xsl:value-of select="xsd:restriction[@base='xsd:decimal']/xsd:minInclusive/@value"/> through <xsl:value-of select="xsd:restriction[@base='xsd:decimal']/xsd:maxInclusive/@value"/>).
                      <br/>
                    </xsl:when>
                  </xsl:choose>
                </span>
              </p>
            </td>
          </tr>
        </table>
      </xsl:when>      
      <xsl:when test="$tabSize=0">
        <p class='MsoNormal'>
          <span style='font-family:"Courier New"'>
            <xsl:value-of select="concat(string($iIndex), '. ')"/>
            <!--<a href='./UnderConstruction.htm'>-->
            <u><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudName']"/>
            </u>
            <!--</a>-->
            <br/>
            <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudExplanation']"/>
            <br/>
            <br/>
            <xsl:choose>
              <xsl:when test="xsd:restriction[@base='xsd:string']/xsd:pattern">
                ALLOWABLE ENTRIES:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><span style="color:maroon">
                  <xsl:value-of select="xsd:restriction/xsd:pattern/@value"/>
                  <br/><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:documentation"/>
                </span><br/><br/>
              </xsl:when>
              <xsl:when test="count(xsd:restriction[@base='xsd:string']/xsd:enumeration) > 1">
                ALLOWABLE ENTRIES: Click <a href="javascript:GetEnumList('{$FieldNameType}', '{$fPath}')">here</a> for the list of allowable values.<br/><br/>
              </xsl:when>
              <xsl:when test="count(xsd:restriction[@base='xsd:string']/xsd:enumeration) = 1">
                ALLOWABLE ENTRIES: <span style="color:maroon">
                  <xsl:value-of select="xsd:restriction/xsd:enumeration/@value"/>
                </span>
                <br/>
              </xsl:when>
              <xsl:when test="xsd:restriction[@base='xsd:integer']/xsd:pattern">
                <!--<xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='FudName']"/>-->
                <br/>
                ALLOWABLE ENTRIES: INTEGER<br/>
                Min Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MinimumLength']"/><br/>
                Max Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MaximumLength']"/><br/>
                Range: (<xsl:value-of select="xsd:restriction[@base='xsd:integer']/xsd:minInclusive/@value"/> through <xsl:value-of select="xsd:restriction[@base='xsd:integer']/xsd:maxInclusive/@value"/>).
                <br/>
              </xsl:when>
              <xsl:when test="xsd:restriction[@base='xsd:decimal']/xsd:pattern">
                ALLOWABLE ENTRIES: DECIMAL NUMBER<br/>
                Min Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MinimumLength']"/><br/>
                Max Length:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()='MaximumLength']"/><br/>
                Min Decimal Places:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:appinfo/*[name()='MinimumDecimalPlaces']"/><br/>
                Max Decimal Places:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="xsd:restriction/xsd:annotation/xsd:appinfo/*[name()='MaximumDecimalPlaces']"/><br/>
                Range: (<xsl:value-of select="xsd:restriction[@base='xsd:decimal']/xsd:minInclusive/@value"/> through <xsl:value-of select="xsd:restriction[@base='xsd:decimal']/xsd:maxInclusive/@value"/>).
                <br/>
              </xsl:when>
            </xsl:choose>
          </span>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="tFieldExplanation">
          <xsl:with-param name="tabSize" select="5"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="break">
    <xsl:param name="text" select="."/>
    <xsl:choose>
      <xsl:when test="contains($text, '&#xA;')">
        <xsl:value-of select="substring-before($text, '&#xA;')"/>
        <br/>
        <xsl:call-template name="break">
          <xsl:with-param name="text" select="substring-after($text,'&#xA;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
