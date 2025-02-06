<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">
    
    <xsl:output method="html"/>
    
    <!-- VARIABLE CONTENANT LES URL -->
    <xsl:variable name="tolkienGateway">https://tolkiengateway.net/wiki/Main_Page</xsl:variable>
    
    <!-- VARIABLE DU HEAD DU DOCUMENT HTML -->
    <xsl:variable name="head">
            <head>
                <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <link rel="stylesheet" href="style.css">
                            <title>Tolkien to XML</title>
                        </link>
                    </meta>
                </meta>
            </head>
    </xsl:variable>
    
    <!-- VARIABLE DU FOOTER -->
    <xsl:variable name="footer">
        <footer>
            <hr/>
            <div id="footer"><p>Site réalisé dans le cadre du cours de XSLT du Master TNAH de l'École nationale des
                chartes.</p></div>
            <img src="img/logo_chartes.png" id="footer"/>
        </footer>
    </xsl:variable>
    
    <!-- VARIABLE DE LA NAVBAR -->
    <xsl:variable name="navbar">
        <div id="navbar">
            <ul>
               <li><a href="index.html">Accueil</a></li>
               <!--<li><a href="extrait1.html">Les contes perdus</a></li>
               <li><a href="extrait2.html">Le Silmarillion</a></li>-->
                
                <xsl:for-each select="//body/div"></xsl:for-each>
                
               <li><a href="toc.html">Index des noms</a></li>
            </ul>
        </div>
    </xsl:variable>
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
</xsl:stylesheet>
