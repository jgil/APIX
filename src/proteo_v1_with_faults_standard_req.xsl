<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:head="http://xmlns.bancsabadell.com/proteo/SharedResources/Header">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

    <xsl:variable name="cnRequestHref">
        <xsl:value-of select="/transformation/cnRequest/@href"/>
    </xsl:variable>

    <xsl:variable name="sourcens">
        <xsl:value-of select="namespace-uri(document($cnRequestHref)//soapenv:Body/*[1])"/>
    </xsl:variable>

    <xsl:variable name="targetns">
        <xsl:value-of select="mapUtils:getTargetNamespace($sourcens)" xmlns:mapUtils="java:com.bs.proteo.apix.transform.Mappings"/>
    </xsl:variable>

    <xsl:variable name="requestMessage">
        <xsl:value-of select="name(document($cnRequestHref)//soapenv:Body/*[1])"/>
    </xsl:variable>

    <xsl:variable name="domainns">
        <xsl:value-of select="namespace-uri(document($cnRequestHref)//*[local-name()='InputData'])"/>
    </xsl:variable>

    <xsl:variable name="sessionId">
        <xsl:value-of select="document($cnRequestHref)//head:HeaderRequest/head:HostRequest/head:sessionId"/>
    </xsl:variable>

    <xsl:variable name="trackingId">
        <xsl:value-of select="document($cnRequestHref)//head:HeaderRequest/head:trackingId"/>
    </xsl:variable>

    <xsl:variable name="language">
        <xsl:value-of select="document($cnRequestHref)//head:HeaderRequest/head:language"/>
    </xsl:variable>

    <xsl:variable name="authorizationId">
        <xsl:value-of select="document($cnRequestHref)//head:HeaderRequest/head:HostRequest/head:authorizationId"/>
    </xsl:variable>

    <xsl:template match="/">
        <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
                       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xmlns:xs="http://www.w3.org/2001/XMLSchema"
                       xmlns:v5="http://proteo.bs.com/soa/architecture/v5/">
            <soap:Header>
                <v5:Properties>
                    <property>
                        <key>HEADER.SESSION_ID</key>
                        <value xsi:type="xs:string">
                            <xsl:copy-of select="$sessionId"/>
                        </value>
                    </property>
                    <property>
                        <key>HEADER.TRACKING_ID</key>
                        <value xsi:type="xs:string">
                            <xsl:copy-of select="$trackingId"/>
                        </value>
                    </property>
                    <property>
                        <key>HEADER.SERVICE_LANGUAGE</key>
                        <value xsi:type="xs:string">
                            <xsl:copy-of select="$language"/>
                        </value>
                    </property>
                    <property>
                        <key>HEADER.SERVICE_COUNTRY</key>
                        <value xsi:type="xs:string">ES</value>
                    </property>
                    <property>
                        <key>HEADER.USER.INTERNAL_ID</key>
                        <value xsi:type="xs:string">V1USER</value>
                    </property>
                    <property>
                        <key>HEADER.USER.INTERNAL_TYPE</key>
                        <value xsi:type="xs:string">V1TYPE</value>
                    </property>
                    <property>
                        <key>HEADER.USER.NAME</key>
                        <value xsi:type="xs:string">V1USER</value>
                    </property>
                    <property>
                        <key>HEADER.SERVICE_CHANNEL</key>
                        <value xsi:type="xs:string">web</value>
                    </property>
                    <property>
                        <key>HEADER.SERVICE_PROCEDENCE</key>
                        <value xsi:type="xs:string">web</value>
                    </property>
                    <property>
                        <key>HEADER.AUTHORIZATIONID</key>
                        <value xsi:type="xs:string">
                            <xsl:copy-of select="$authorizationId"/>
                        </value>
                    </property>
                </v5:Properties>
            </soap:Header>
            <soap:Body>
                <xsl:element name="{$requestMessage}" namespace="{$targetns}" >
                    <xsl:element name="dom:InputData" namespace="{$domainns}">
                        <xsl:for-each select="document($cnRequestHref)//*[local-name()='InputData']/*">
                            <xsl:apply-templates mode="copy" select="." />
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </soap:Body>
        </soap:Envelope>
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
