<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="TEI.2 teiHeader fileDesc div lg"/>
    
    <!-- 
        Transform TEI Encoding of Plays in CAMENA - Latin Texts of Early Modern Europe. Corpus Automatum Multiplex Electorum Neolatinitatis Auctorum
        (http://mateo.uni-mannheim.de/camenahtdocs/camena_e.html) to a simple DraCor conformant TEI to be included into JesDraCor (https://github.com/alexander-winkler/JesDraCor) 
        Author: Ingo Börner (ingo.boerner@uni-potsdam.de)
    -->
    
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
    
    <!-- root element should be <TEI>, add TEI-namespace, language = Latin -->
    <xsl:template match="TEI.2">
        <!-- add language ISO-639 Language Code for Latin -->
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang="lat">
            <xsl:apply-templates/>
        </TEI>
    </xsl:template>
    
    <!-- teiHeader: remove @type -->
    <xsl:template match="teiHeader">
        <teiHeader xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
            <xsl:call-template name="profileDesc"/>
            <xsl:call-template name="revisionDesc"/>
        </teiHeader>
    </xsl:template>
    
    <!-- fileDesc -->
    <xsl:template match="fileDesc">
        <fileDesc xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </fileDesc>
    </xsl:template>
    
    <!-- titleStmt -->
    <!-- DraCor uses main/sub -->
    <!-- will be corrected manually -->
    <xsl:template match="titleStmt">
        <titleStmt xmlns="http://www.tei-c.org/ns/1.0">
            <title type="main">
                <!-- what should be used as title? -->
                <xsl:comment>
                    <xsl:value-of select="lower-case(//body/div1/head[1])"/>
                </xsl:comment>
            </title>
            <title type="sub">
                <xsl:comment>add subtitle or remove whole title element</xsl:comment>
            </title>
            <xsl:apply-templates select="author"/>
        </titleStmt>
    </xsl:template>
    
    <!-- remove additional title elements if present in Camena -->
    <xsl:template match="title[parent::titleStmt]"/>
    
    <!-- author -->
    <!-- will be corrected manually -->
    <xsl:template match="author">
        <author xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:comment><xsl:value-of select="."/></xsl:comment>
            <persName>
                <forename><xsl:comment>forename</xsl:comment></forename>
                <surname><xsl:comment>surname</xsl:comment></surname>
            </persName>
            <idno type="wikidata"><xsl:comment>Add Q-Number from Wikidata, see also: Overview table in Readme https://github.com/alexander-winkler/JesDraCor</xsl:comment></idno>
        </author>
    </xsl:template>
    
    <!-- remove the editor form titleStmt -->
    <xsl:template match="editor[parent::titleStmt]"/>
    
    <!-- publicationStmt -->
    <!-- Original information on the publication on the CAMENA platform will be moved to sourceDesc -->
    <xsl:template match="publicationStmt">
        <publicationStmt xmlns="http://www.tei-c.org/ns/1.0">
            <publisher xml:id="dracor">DraCor</publisher>
            <idno type="URL">https://dracor.org</idno>
            <idno type="dracor" xml:base="https://dracor.org/id/"><xsl:comment>DraCor-ID – will be added later</xsl:comment></idno>
            <availability>
                <licence>
                    <ab><xsl:comment>add licence here + machine readable version in the attribute @taget of the element below: CC-BY ?</xsl:comment></ab>
                    <ref target="add-url-here">Licence</ref>
                </licence>
            </availability>
            <idno type="wikidata" xml:base="http://www.wikidata.org/entity/">
                <xsl:comment>add Q-Number of play from Wikidata if available (dramas, that are not included in WD yet could also be added!)</xsl:comment>
            </idno>
        </publicationStmt>
    </xsl:template>
    
    <!-- sourceDesc -->
    <!-- in DraCor: 2 "sources", digital file + print edition, that was digitized -->
    <xsl:template match="sourceDesc">
        <sourceDesc xmlns="http://www.tei-c.org/ns/1.0">
            <bibl type="digitalSource">
                <name>CAMENA – Corpus Automatum Multiplex Electorum Neolatinitatis Auctorum</name>
                <idno type="URL"><xsl:comment>add url to CAMENA TEI download here, see also see also: Overview table in Readme https://github.com/alexander-winkler/JesDraCor</xsl:comment></idno>
                <availability>
                    <licence>
                        <ab>CC-BY-3.0</ab>
                        <ref target="http://creativecommons.org/licenses/by/3.0/en/legalcode">Licence</ref>
                    </licence>
                </availability>
            </bibl>
            <bibl type="originalSource">
                <title>
                    <xsl:value-of select="//teiHeader/fileDesc/sourceDesc/bibl/text()"/>
                </title>
                <!-- DraCor dates -->
                <date type="print" when=""><xsl:comment>date printed: ISO year to attribute @when</xsl:comment></date>
                <date type="premiere" when=""><xsl:comment>date premiered</xsl:comment></date>
                <date type="written" when=""><xsl:comment>date written</xsl:comment></date>
            </bibl>
        </sourceDesc>
    </xsl:template>
    
    <!-- remove additional teiHeader elements notesStmt, editionStmt, encodingDesc, revisionDesc -->
    <xsl:template match="notesStmt"/>
    <xsl:template match="editionStmt"/>
    <xsl:template match="encodingDesc"/>
    <xsl:template match="revisionDesc"/>
    
    
    <!-- profileDesc -->
    <xsl:template name="profileDesc" xmlns="http://www.tei-c.org/ns/1.0">
        <profileDesc>
            <particDesc>
                <listPerson>
                    <xsl:comment>Characters must be added here and linked to the text</xsl:comment>
                </listPerson>
            </particDesc>
            <textClass xmlns="http://www.tei-c.org/ns/1.0">
                <xsl:comment>Classification of text with keywords</xsl:comment>
            </textClass>
        </profileDesc>
    </xsl:template>
    
    <!-- revisionDesc -->
    <xsl:template name="revisionDesc">
        <revisionDesc xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:variable name="date" select="current-date()"/>
            <listChange>
                <change when="{$date}">file conversion from source</change>
            </listChange>
        </revisionDesc>
    </xsl:template>

    <!-- text -->
    <xsl:template match="text">
        <text xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </text>
    </xsl:template>
    
    <!-- body -->
    <xsl:template match="body">
        <body xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </body>
    </xsl:template>
    
    <!-- convert the numbered divs to ordinary div elements -->
    <xsl:template match="div1|div2|div3|div4|div5|div6">
        <div xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type">
                <xsl:value-of select="@type"/>
            </xsl:attribute>
          <xsl:apply-templates/>  
        </div>
    </xsl:template>
    
    <!-- head -->
    <xsl:template match="head">
        <head xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </head>
    </xsl:template>
    
    <!-- pb -->
    
    <xsl:template match="pb">
        <pb xmlns="http://www.tei-c.org/ns/1.0" n="{@n}">
        </pb>
        <!-- keep as comment for reference for now -->
        <xsl:comment>pb: id=<xsl:value-of select="@id"/></xsl:comment>
    </xsl:template>
    
    <!-- lg -->
    
    <!-- remove them in the first place, re-add them in the sp elements if necessary? -->
    <xsl:template match="lg[not(ancestor::sp)]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- there are correct lg inside sp elements -->
    <xsl:template match="lg[ancestor::sp]">
        <lg xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </lg>
    </xsl:template>
    
    
    <!-- l -->
    <!-- keep the verses; need to be moved into sp - lg -->
    <xsl:template match="l">
        <l xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </l>
    </xsl:template>
    
    <!-- p -->
    <xsl:template match="p">
        <p xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <!-- some dramas already contain drama mark-up -->
    
    <!-- stage -->
    
    <xsl:template match="stage">
        <stage xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </stage>
    </xsl:template>
    
    <!-- sp -->
    <xsl:template match="sp">
        <sp xmlns="http://www.tei-c.org/ns/1.0">
            <!-- if attribute @who is present, make lower case and transform into pointer -->
            <xsl:if test="@who">
                <xsl:attribute name="who">
                    <xsl:value-of select="concat('#', lower-case(@who))"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </sp>
    </xsl:template>
    
</xsl:stylesheet>