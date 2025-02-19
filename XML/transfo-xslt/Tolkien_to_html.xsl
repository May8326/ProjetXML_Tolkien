<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">
    
    <xsl:output method="html"/>
    
    <!-- VARIABLE CONTENANT LES URL -->
    <xsl:variable name="tolkienGateway">https://tolkiengateway.net/wiki/Main_Page</xsl:variable>
    
    <!-- CLES DU FICHIER -->
    <xsl:key name="biblio" match="//bibl" use="@xml:id"/>
    
    <!-- VARIABLE DU HEAD DU DOCUMENT HTML -->
    <xsl:variable name="head">
        <head>
            <meta charset="UTF-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
            <link rel="stylesheet" href="style.css"/>
            <title>Tolkien to XML</title>
        </head>
    </xsl:variable>
    
    <!-- VARIABLE DU FOOTER -->
    <xsl:variable name="footer">
        <footer>
            <hr/>
            <div id="footer">
                <p>Site réalisé dans le cadre du cours de XSLT du Master TNAH de l'École nationale des chartes.</p>
                <a href="https://www.chartes.psl.eu"><img src="./img/logo_chartes.png" id="footer"/></a>
            </div>
        </footer>
    </xsl:variable>
    
    
    <!-- VARIABLE DE LA NAVBAR -->
    <xsl:variable name="navbar">
        <div id="navbar">
            <ul>
               <li><a href="index.html">Accueil</a></li>
               <!--<li><a href="extrait1.html">Les contes perdus</a></li>
               <li><a href="extrait2.html">Le Silmarillion</a></li>-->
                <xsl:for-each select="//body/div">
                    <xsl:variable name="numero-div" select="@n"/>
                    <li><a href="extrait{$numero-div}.html">Extrait n°<xsl:value-of select="$numero-div"/> : <xsl:value-of select="key('biblio', @source)/title"/>
                        </a></li>
                </xsl:for-each>
               <li><a href="toc.html">Index des noms</a></li>
            </ul>
        </div>
    </xsl:variable>
    
    <!-- TEMPLATE QUI MATCHE LA RACINE ET APPELLE LES TEMPLATES -->
    <xsl:template match="/">
        <xsl:call-template name="index"/>
        <xsl:call-template name="extraits"/>
        <xsl:call-template name="toc"/>
        <!-- À COMPLÉTER EN AJOUTANT LES <XSL:CALL-TEMPLATE/> POUR LES CHAPITRES ET L'INDEX -->
    </xsl:template> 
    

    <!-- TEMPLATE DE LA PAGE D'ACCUEIL -->
    <xsl:template name="index">
       <xsl:result-document href="out/index.html" indent="yes">
           <html>
               <xsl:copy-of select="$head"/>
               <body>
                   <xsl:copy-of select="$navbar"/>
                   <h1>TITRE DU SITE</h1>
                   <div><p>Description du site</p></div>
               </body>
               <xsl:copy-of select="$footer"/>
           </html>
       </xsl:result-document>
   </xsl:template>
    
    <!-- TEMPLATE DES PAGES D'EXTRAITS -->
   <xsl:template name="extraits">
       <xsl:for-each select="//body/div">
           <xsl:result-document href="{concat('out/', 'extrait', @n, '.html')}" indent="yes">
           <html>
               <xsl:copy-of select="$head"/>
               <body>
                   <xsl:copy-of select="$navbar"></xsl:copy-of>
                   <h1>TITRE DE L'EXTRAIT</h1>
                   <xsl:for-each select="/p">
                       <p>
                       <xsl:value-of select="."/>
                       </p>
                   </xsl:for-each>
               </body>
               <xsl:copy-of select="$footer"/>
           </html>
           </xsl:result-document>
       </xsl:for-each>
   </xsl:template>
    
    <xsl:template name="toc">
        <xsl:result-document href="out/toc.html" indent="yes">
            <html>
                <xsl:copy-of select="$head"/>
                <body>
                    <xsl:copy-of select="$navbar"></xsl:copy-of>
                    <h1>TITRE DE L'INDEX</h1>
                    <div><p>Description du site</p></div>
                </body>
                <xsl:copy-of select="$footer"/>
            </html>
        </xsl:result-document>
    </xsl:template>
    
   
    
    
    
    
    
    
    
    
    
    
    
    
</xsl:stylesheet>
