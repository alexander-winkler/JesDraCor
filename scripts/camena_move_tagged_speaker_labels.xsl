<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output encoding="UTF-8" indent="yes"/>
    
    <!-- 
        Fallback "Identity Transform":
        If no other rule is in place, keep everything as is:
    -->
    
    <xsl:template match="@*|*|processing-instruction()|comment()">
        <xsl:copy>
            <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- root -->
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- match sp elements that have <speaker> in the first line -->
    <xsl:template match="tei:sp[tei:lg[1]/tei:l[1][tei:speaker]]" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:element name="sp">
            <!-- copy all attributes -->
            <xsl:copy-of select="@*"/>
            <xsl:element name="speaker">
                <xsl:value-of select="./tei:lg[1]/tei:l[1]/tei:speaker/string()"/>
            </xsl:element>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- remove the speaker label from the verse line -->
    <xsl:template match="tei:speaker[ancestor::tei:l[1]]"/>
    
</xsl:stylesheet>