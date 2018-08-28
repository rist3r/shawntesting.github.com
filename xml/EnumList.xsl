<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="html" indent="yes"/>
	<!-- Author:	         Thien Hoang -->
	<!-- Company:       Northrop Grumman Space & Mission Systems -->
	<!-- Supporting:     United States (US) Department of Defense (DoD), Defense Information Systems Agency (DISA) GE332 -->
	<!-- Last Modified: 1 APR 2007 -->
  <xsl:param name="fieldNameType"/>

  <xsl:template match="/">
    <!-- CSS Stylesheet -->
    
    <!-- End CSS Stylesheet -->
    <!-- Variable Declarations -->
    <!-- The 'baseline' variable contains the baseline release (e.g. '2006Ch1', '2008', etc) because it is used in multiple locations. -->
    
    <xsl:variable name="statusDate"></xsl:variable>
    <!-- The 'versionDate' variable contains the Version Date (e.g. '31 Mar 2007', etc) because it is not contained in the XML-MTF schema -->
    <xsl:variable name="versionDate"></xsl:variable>
    <!-- The 'classification' variable contains the Classification of the Message Text Format (i.e. 'U', 'C', 'S' or 'TS') because it is not contained in the XML-MTF schema -->
    <!-- As of the 2008 Baseline, all US Message Text Formats are Unclassified, so this value has been hard coded as 'U' for lack of a dynamic method for obtaining this information. -->
    <xsl:variable name="classification">U</xsl:variable>


    <!--xsl:variable name="MsgId"><xsl:value-of select="/xsd:schema/xsd:element/xsd:annotation/xsd:appinfo/*[name()='MtfIdentifier']"/></xsl:variable-->
    <!-- End Variable Declarations -->
    <!-- HTML and XSLT -->
    <html>
      <head>
        <title>
          USMTF MIL-STD-6040B - List of allowable entries for <xsl:value-of select="$fieldNameType"/> Version 
          <xsl:value-of select="/xsd:schema/xsd:simpleType[@name = $fieldNameType]/xsd:annotation/xsd:appinfo/*[name()='VersionIndicator']"/>
        </title>
        <link rel="stylesheet" type="text/css" href="./set_report.css"/>
      </head>
      <body>
        <!-- Begin Layout of Field Format Metadata -->

        <p class="MsoNormal">
          <b>
            <span style='font-size:10.0pt;font-family:"Courier New"'>UNCLASSIFIED</span>
          </b>
        </p>

        <table class='MsoTableGrid' border='0' cellspacing='0' cellpadding='0' width='700'
         style='border-collapse:collapse;border:none'>
          <tr>
            <td width='295' valign='top' style='width:221.4pt;border:solid windowtext 1.0pt; 
            background:#D9D9D9;padding:0in 5.4pt 0in 5.4pt'>
              <p class='MsoNormal'>
                <b>
                  <span style='font-size:10.0pt;font-family:"Courier New"'>
                    ELEMENTAL FIELD NUMBER: <xsl:value-of select="/xsd:schema/xsd:simpleType[@name = $fieldNameType]/xsd:annotation/xsd:appinfo/*[name()='FieldFormatIndexReferenceNumber']"/>/<xsl:value-of select="/xsd:schema/xsd:simpleType[@name = $fieldNameType]/xsd:annotation/xsd:appinfo/*[name()='FudNumber']"/>
                  </span>
                </b>
              </p>
            </td>
            <td width='240' valign='top' style='width:2.5in;border:solid windowtext 1.0pt; 
            border-left:none;padding:0in 5.4pt 0in 5.4pt'>
              <p class='MsoNormal' align='center' style='text-align:center'>
                <b>
                  <span  style='font-size:10.0pt;font-family:"Courier New"'></span>
                </b>
              </p>
              <p class='MsoNormal' align='center' style='text-align:center'>
                <span  >
                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </span>
              </p>
            </td>
            <td width='252' valign='top' style='width:189.0pt;border:solid windowtext 1.0pt; 
            border-left:none;padding:0in 5.4pt 0in 5.4pt'>
              <p class='MsoNormal'>
                <b>
                  <span style='font-size:10.0pt;font-family:"Courier New"'>STATUS: </span>
                </b>
                <span  style='font-size:10.0pt;font-family:"Courier New"'>AGREED</span>
              </p>
              <p class='MsoNormal'>
                <b>
                  <span style='font-size:10.0pt;font-family:"Courier New"'>
                     
                  </span>
                </b>
                <span style='font-size:10.0pt;font-family:"Courier New"'>
                  <xsl:value-of select='$statusDate'/>
                </span>
              </p>
              <p class='MsoNormal'>
                <span >
                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </span>
              </p>
            </td>
          </tr>
          <tr>
            <td width='535' colspan='2' valign='top' style='width:401.4pt;border:solid windowtext 1.0pt; 
            border-top:none;background:#D9D9D9;padding:0in 5.4pt 0in 5.4pt'>
              <p class='MsoNormal'>
                <b>
                  <span style='font-size:10.0pt;font-family:"Courier New"'>
                    ELEMENTAL FIELD NAME: <xsl:value-of select="/xsd:schema/xsd:simpleType[@name = $fieldNameType]/xsd:annotation/xsd:appinfo/*[name()='FudName']"/>
                  </span>
                </b>
              </p>
            </td>
            <td width='252' valign='top' style='width:189.0pt;border-top:none;border-left: none;
            border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt; padding:0in 5.4pt 0in 5.4pt'>
              <p class='MsoNormal'>
                <b>
                  <span style='font-size:10.0pt;font-family:"Courier New"'>VERSION: </span>
                <xsl:value-of select="/xsd:schema/xsd:simpleType[@name = $fieldNameType]/xsd:annotation/xsd:appinfo/*[name()='VersionIndicator']"/>
                </b>
                <!--span style='font-size:10.0pt;font-family:"Courier New"'>B.0.01.00</span-->
              </p>
              <p class='MsoNormal'>
                <b>
                  <span style='font-size:10.0pt;font-family:"Courier New"'>
                    
                  </span>
                </b>
                <span style='font-size:10.0pt;font-family:"Courier New"'>
                  <xsl:value-of select='$versionDate'/>
                </span>
              </p>
              <p class='MsoNormal'>
                <span style='font-size:10.0pt;font-family:"Courier New"'>
                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </span>
              </p>
            </td>
          </tr>
        </table>
        <br/>
        <br/>
        <hr style="CLEAR:left;WIDTH:100%;COLOR:black"/>
        
        <!-- End Layout of Field Metadata -->
        <!-- Begin Layout of Enumeration Data -->
        <br/>
        <span style="clear:left">
          <div id="Enumlist">
            <p class='MsoNormal'>
              <span style='font-size:10.0pt;font-family:"Courier New"'>
                LIST OF ALLOWABLE VALUES:<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
              </span>
            </p>
            <br/>
            <table border="1" cellpadding="10">
              <tr>
                <th width="3%" style='background:#ffdd33;padding:16pt;height:37.5pt'>
                  <p class='MsoNormal'>
                    <span style='font-family:"Courier New"; text-align:center'>
                      <b>Seq#</b>
                    </span>
                  </p>
                </th>
                <th  width="15%" style='background:#ffdd33;padding:16pt;height:37.5pt'>
                  <p class='MsoNormal'>
                    <span >
                      <b>Data Code</b>
                    </span>
                  </p>
                </th>
                <th width="40%" style='background:#ffdd33;padding:16pt;height:37.5pt'>
                  <p class='MsoNormal'>
                    <span >
                      <b>Data Item</b>
                    </span>
                  </p>
                </th>
                <th width="42%" style='background:#ffdd33;padding:16pt;height:37.5pt'>
                  <p class='MsoNormal'>
                    <span >
                      <b>Explanation</b>
                    </span>
                  </p>
                </th>
              </tr>
              
              <xsl:for-each select="/xsd:schema/xsd:simpleType[@name = $fieldNameType]/xsd:restriction[@base='xsd:string']/xsd:enumeration">
                <tr>
                  <td width="3%" style='background:#ffffcc;padding:16pt;height:37.5pt'>
                    <p class='MsoNormal'>
                      <span >
                        <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()= 'DataItemSequenceNumber']"/>
                      </span>
                    </p>
                  </td>
                  <td  width="15%" style='background:#ffffcc;padding:16pt;height:37.5pt'>
                    <p class='MsoNormal'>
                      <span >
                        <xsl:value-of select='@value'/>
                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                      </span>
                    </p>
                  </td>
                  <td width="40%" style='background:#ffffcc;padding:16pt;height:37.5pt'>
                    <p class='MsoNormal'>
                      <span >
                        <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()= 'DataItem']"/>
                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                      </span>
                    </p>
                  </td>
                  <td width="42%" style='background:#ffffcc;padding:16pt;height:37.5pt'>
                    <p class='MsoNormal'>
                      <span >
                        <xsl:value-of select="xsd:annotation/xsd:appinfo/*[name()= 'Explanation']"/>
                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                      </span>
                    </p>
                  </td>
                </tr>
              </xsl:for-each>
            </table>
          </div>
        </span>
      </body>
    </html>
  </xsl:template>
	<!-- End template to process each SN explanation statement -->
	<!-- End Additional Template Definitions -->
</xsl:stylesheet>

