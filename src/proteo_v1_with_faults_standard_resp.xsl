<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:v5="http://proteo.bs.com/soa/architecture/v5/">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

    <xsl:variable name="sbResponseHref" select="/transformation/sbResponse/@href"/>

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="document($sbResponseHref)//SOAP-ENV:Fault != ''">
                <xsl:choose>
                    <xsl:when test="document($sbResponseHref)//ProteoFault != ''">
                        <!-- Architecture error -->
                        <xsl:variable name="proteoFault" select="document($sbResponseHref)//ProteoFault"/>
                        <xsl:variable name="faultCode" select="$proteoFault/faultCode/text()"/>
                        <xsl:variable name="faultDescription" select="$proteoFault/faultDescription/text()"/>
                        <xsl:variable name="nativeFault" select="$proteoFault/ns2:Properties/property[key='NativeError']/value" xmlns:ns2="http://proteo.bs.com/soa/architecture/v5/"/>
                        <xsl:variable name="trackingId" select="$proteoFault/ns2:Properties/property[key='HEADER.TRACKING_ID']/value/text()" xmlns:ns2="http://proteo.bs.com/soa/architecture/v5/"/>
                        <xsl:variable name="status" select="$proteoFault/ns2:Properties/property[key='HEADER.STATUS']/value/text()" xmlns:ns2="http://proteo.bs.com/soa/architecture/v5/"/>
                        <xsl:variable name="errorSource" select="$proteoFault/ns2:Properties/property[key='FAULT_ERROR_SOURCE']/value/text()" xmlns:ns2="http://proteo.bs.com/soa/architecture/v5/"/>

                        <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
                            <SOAP-ENV:Body>
                                <SOAP-ENV:Fault>
                                    <faultcode>
                                        <xsl:copy-of select="$nativeFault/faultCode/text()"/>
                                    </faultcode>
                                    <faultstring>
                                        <xsl:copy-of select="$nativeFault/faultDescription/text()"/>
                                    </faultstring>
                                    <faultactor>DefaultRole</faultactor>
                                    <detail>
                                        <ns2:FaultInfo xmlns:ns2="http://xmlns.bancsabadell.com/proteo/SharedResources/ErrorSchema">
                                            <ns2:HeaderResponse>
                                                <ns2:trackingId>
                                                    <xsl:copy-of select="$trackingId"/>
                                                </ns2:trackingId>
                                                <ns2:status>
                                                    <xsl:copy-of select="$status"/>
                                                </ns2:status>
                                            </ns2:HeaderResponse>
                                            <ns2:CommonFault>
                                                <ns2:faultCode>
                                                    <xsl:copy-of select="$errorSource"/>
                                                </ns2:faultCode>
                                                <ns2:faultMessage>
                                                    <xsl:copy-of select="$faultDescription"/>
                                                </ns2:faultMessage>
                                            </ns2:CommonFault>
                                            <ns2:NativeFault>
                                                <ns2:faultCode>
                                                    <xsl:copy-of select="$nativeFault/faultCode/text()"/>
                                                </ns2:faultCode>
                                                <ns2:faultMessage>
                                                    <xsl:copy-of select="$nativeFault/faultDescription/text()"/>
                                                </ns2:faultMessage>
                                            </ns2:NativeFault>
                                        </ns2:FaultInfo>
                                    </detail>
                                </SOAP-ENV:Fault>
                            </SOAP-ENV:Body>
                        </SOAP-ENV:Envelope>

                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Generic error -->

                        <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
                            <SOAP-ENV:Body>
                                <SOAP-ENV:Fault>
                                    <faultcode>
                                        <xsl:copy-of select="document($sbResponseHref)//faultcode/text()"/>
                                    </faultcode>
                                    <faultstring>
                                        <xsl:copy-of select="document($sbResponseHref)//faultstring/text()"/>
                                    </faultstring>
                                    <faultactor>
                                        <xsl:copy-of select="document($sbResponseHref)//faultactor/text()"/>
                                    </faultactor>
                                    <detail>
                                        <ns2:FaultInfo xmlns:ns2="http://xmlns.bancsabadell.com/proteo/SharedResources/ErrorSchema">
                                            <ns2:NativeFault>
                                                <ns2:faultCode>
                                                    <xsl:copy-of select="document($sbResponseHref)//faultcode/text()"/>
                                                </ns2:faultCode>
                                                <ns2:faultMessage>
                                                    <xsl:copy-of select="document($sbResponseHref)//faultstring/text()"/>
                                                </ns2:faultMessage>
                                            </ns2:NativeFault>
                                        </ns2:FaultInfo>
                                    </detail>
                                </SOAP-ENV:Fault>
                            </SOAP-ENV:Body>
                        </SOAP-ENV:Envelope>

                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- Correct response -->

                <xsl:variable name="targetns" select="namespace-uri(document($sbResponseHref)//SOAP-ENV:Body/*[1])"/>
                <xsl:variable name="sourcens" select="mapUtils:getSourceNamespace($targetns)" xmlns:mapUtils="java:com.bs.proteo.apix.transform.Mappings"/>
                <xsl:variable name="responseMessage" select="name(document($sbResponseHref)//SOAP-ENV:Body/*[1])"/>
                <xsl:variable name="domainns" select="namespace-uri(document($sbResponseHref)//*[local-name()='OutputData'])"/>
                <xsl:variable name="status" select="document($sbResponseHref)//v5:Properties/property[key='HEADER.STATUS']/value/text()"/>
                <xsl:variable name="sessionId" select="document($sbResponseHref)//v5:Properties/property[key='HEADER.SESSION_ID']/value/text()"/>
                <xsl:variable name="trackingId" select="document($sbResponseHref)//v5:Properties/property[key='HEADER.TRACKING_ID']/value/text()"/>
                <xsl:variable name="autorizationId" select="document($sbResponseHref)//v5:Properties/property[key='HEADER.AUTHORIZATIONID']/value/text()"/>

                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                                  xmlns:head="http://xmlns.bancsabadell.com/proteo/SharedResources/Header">

                    <soapenv:Body>
                        <xsl:element name="{$responseMessage}" namespace="{$sourcens}">
                            <head:HeaderResponse>
                                <head:trackingId>
                                    <xsl:copy-of select="$trackingId"/>
                                </head:trackingId>
                                <head:step>0</head:step>
                                <head:status>
                                    <xsl:copy-of select="$status"/>
                                </head:status>
                                <head:HostResponse>
                                    <head:sessionId>
                                        <xsl:copy-of select="$sessionId"/>
                                    </head:sessionId>
                                    <head:authorizationId>
                                        <xsl:copy-of select="$autorizationId"/>
                                    </head:authorizationId>
                                </head:HostResponse>
                            </head:HeaderResponse>
                            <xsl:element name="mes:OutputData" namespace="{$domainns}">
                                <xsl:for-each select="document($sbResponseHref)//*[local-name()='OutputData']/*">
                                    <xsl:apply-templates mode="copy" select="." />
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                    </soapenv:Body>
                </soapenv:Envelope>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="copy">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <xsl:apply-templates select="@*|node()" mode="copy" />
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*|text()|comment()" mode="copy">
        <xsl:copy/>
    </xsl:template>

</xsl:stylesheet>