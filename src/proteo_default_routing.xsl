<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
        >

    <xsl:template match="/">

        <xsl:variable name="nbRequestHref">
            <xsl:value-of select="/transformation/nbRequest/@href"/>
        </xsl:variable>

        <xsl:variable name="sourcens">
            <xsl:value-of select="namespace-uri(document($nbRequestHref)//soapenv:Body/*[1])"/>
        </xsl:variable>

        <xsl:variable name="routingKey">
            <xsl:value-of select="mapUtils:getRoutingKey($sourcens)" xmlns:mapUtils="java:com.bs.proteo.apix.transform.Mappings"/>
        </xsl:variable>

        <output>
            <xsl:element name="routingKey">
                <xsl:copy-of select="$routingKey"/>
            </xsl:element>
        </output>
    </xsl:template>
</xsl:stylesheet>
