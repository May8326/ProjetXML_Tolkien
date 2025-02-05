<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">
    
    <xsl:output method="html"/>
    
    <!-- VARIABLE CONTENANT LES URL -->
    <xsl:variable name="gallica">https://gallica.bnf.fr/ark:/</xsl:variable>
    <xsl:variable name="gallica-iif">https://gallica.bnf.fr/iiif/ark:/</xsl:variable>
    
    <!-- VARIABLE CONTENANT LE HEAD DES DOCUMENTS HTML -->
    <xsl:variable name="head">
        <head>
            <meta charset="utf-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1"/>
            <link rel="preconnect" href="https://fonts.googleapis.com"/>
            <link rel="preconnect" href="https://fonts.gstatic.com"/>
            <link
                href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&amp;display=swap"
                rel="stylesheet"/>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"/>
            <script src="https://openseadragon.github.io/openseadragon/openseadragon.min.js"/>
            <title>Journal de Jean Le Fèvre</title>
            <style>
                #navbar > ul > li {
                display: inline-block;
                list-style: none;
                }</style>
        </head>
    </xsl:variable>
    
    <!-- VARIABLE CONTENANT LE FOOTER -->
    <xsl:variable name="footer">
        <footer style="margin: 5em 0 0 0;">
            <hr/>
            <p>Site réalisé dans le cadre du cours de XSLT du Master TNAH de l'École nationale des
                chartes.</p>
        </footer>
    </xsl:variable>
    
    <!-- VARIABLE CONTENANT LA NAVBAR -->
    <xsl:variable name="navbar">
        <!-- LIENS POUR LES QUATRE CHAPITRES ET L'INDEX -->
        <div style="text-align: center;" id="navbar">
            <ul>
                <li><a href="home.html">Accueil</a> - </li>
                <xsl:for-each select="//body/div">
                    <xsl:variable name="chapitre-num" select="@n"/>
                    <li>
                        <a href="chapitre{$chapitre-num}.html">Chapitre <xsl:value-of
                            select="$chapitre-num"/></a>
                    </li>
                </xsl:for-each>
                <li>
                    <a href="index.html">Index</a>
                </li>
            </ul>
        </div>
    </xsl:variable>
    
    <!-- TEMPLATE QUI MATCHE LA RACINE ET APPELLE LES TEMPLATES -->
    <xsl:template match="/">
        <xsl:call-template name="home"/>
        <xsl:call-template name="chapitres"/>
        <xsl:call-template name="index"/>
        <!-- À COMPLÉTER EN AJOUTANT LES <XSL:CALL-TEMPLATE/> POUR LES CHAPITRES ET L'INDEX -->
    </xsl:template>
    
    <!-- TEMPLATE CONTENANT LA PAGE D'ACCUEIL DU SITE -->
    <xsl:template name="home">
        <xsl:result-document href="out/home.html" method="html" indent="yes">
            <html>
                <xsl:copy-of select="$head"/>
                <body style="margin: 2em 20em 5em 20em; font-family: 'Roboto', serif;">
                    <xsl:copy-of select="$navbar"/>
                    <h1 style="text-align: center;">Édition numérique du <em><xsl:value-of
                        select="//titleStmt/title"/></em> de <xsl:value-of
                            select="//titleStmt/author"/></h1>
                    
                    <div style="margin: 2em 0 2em 0;">
                        <p>Ce site propose un édition de plusieurs chapitres tirés du livre
                            <em><xsl:value-of select="//biblStruct//title"/></em> de
                            <xsl:value-of select="//biblStruct//editor[1]/name"/> et
                            <xsl:value-of select="//biblStruct//editor[2]/name"/> (<xsl:value-of
                                select="//biblStruct//publisher"/>, <xsl:value-of
                                    select="//biblStruct//date"/>).</p>
                    </div>
                    <div style="margin: 2em 0 2em 0;">
                        <h2>Informations sur le manuscrit:</h2>
                        <!-- QUESTION N°1.3 -->
                        <ul>
                            <li>Institution: <xsl:value-of select="//msIdentifier/repository"/>,
                                <xsl:value-of select="//msIdentifier/settlement"/></li>
                            <li>Cote: <xsl:value-of select="//msIdentifier/idno[@source = 'bnf']"
                            /></li>
                            <li>Numérisation: <a
                                href="{concat($gallica,//msIdentifier/idno[@source='gallica']/text())}"
                                target="blank">lien</a></li>
                        </ul>
                    </div>
                    <div id="visioneuse">
                        <div id="_viewer" style="width: 100%; height: 800px;"/>
                        <!-- QUESTION N°1.4 -->
                        <script type="text/javascript">
                            var _viewer = OpenSeadragon({
                            id: "_viewer",
                            prefixUrl: "https://openseadragon.github.io/openseadragon/images/",
                            sequenceMode: true,
                            /*tileSources:[
                            'https://gallica.bnf.fr/iiif/ark:/12148/btv1b9007462z/f39/info.json',
                            'https://gallica.bnf.fr/iiif/ark:/12148/btv1b9007462z/f40/info.json',
                            'https://gallica.bnf.fr/iiif/ark:/12148/btv1b9007462z/f41/info.json',],*/
                            tileSources:[<xsl:for-each select="//facsimile">
                                '<xsl:value-of select="concat($gallica-iif, ./graphic/@url, '/info.json')"/>',
                            </xsl:for-each>
                            ,]
                            });</script>
                    </div>
                    <div>
                        <h2>Chapitres disponibles:</h2>
                        <ul>
                            <!-- QUESTION N°1.5 -->
                            <xsl:for-each select="//body/div">
                                <xsl:variable name="chapitre-num" select="@n"/>
                                <li>
                                    <a href="chapitre{$chapitre-num}.html">
                                        <xsl:value-of select="./head"/>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                </body>
                <xsl:copy-of select="$footer"/>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    
    <xsl:template name="chapitres">
        <xsl:for-each select="//body/div">
            <xsl:result-document href="{concat('out', '/', 'chapitre', @n, '.html')}"/>
            <html>
                <xsl:copy-of select="$head"/>
                <body style="margin: 2em 20em 5em 20em; font-family: 'Roboto', serif;">
                    <xsl:copy-of select="$navbar"/>
                    <xsl:for-each select="//body/div">
                        <h1 style="text-align: center;">
                            <xsl:value-of select="./head"/>
                        </h1>
                        <div style="margin: 2em 0 2em 0;">
                            <xsl:for-each select="./p">
                                <p>
                                    <xsl:value-of select="."/>
                                </p>
                            </xsl:for-each>
                        </div>
                    </xsl:for-each>
                </body>
                <xsl:copy-of select="$footer"/>
            </html>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="index">
        <xsl:result-document href="out/index.html" method="html">
            <html>
                <xsl:copy-of select="$head"/>
                <body style="margin: 2em 20em 5em 20em; font-family: 'Roboto', serif;">
                    <xsl:copy-of select="$navbar"/>
                    <h1 style="text-align: center;">Index des noms de personnes</h1>
                    <div stule="margin: 2em 0 2em 0;">
                        <!-- Boucle 1 pour grouper les persname et les trier, et créer un p pour chaque groupe -->
                        <xsl:for-each-group select=".//div/p/persName" group-by="./@ref">
                            <xsl:sort select="translate(current-grouping-key(), '_#', ' ')"/>
                            <p><xsl:value-of select="translate(current-grouping-key(), '_#', ' ')"/>:
                                <!-- Boucle 2 pour grouper les apparitions d'un mme individu en fonction desn um des div -->
                                <xsl:for-each-group select="current-group()" group-by="current-group()/ancestor::div/@n">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="concat('chapitre', current-grouping-key(), '.html')"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="current-grouping-key()"/>
                                    </a>
                                    <xsl:if test="position()!= last()">,                                        
                                    </xsl:if>
                                </xsl:for-each-group>
                            </p>
                        </xsl:for-each-group>
                    </div>
                </body>                    
                <xsl:copy-of select="$footer"/>
            </html>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>
