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
            <link rel="stylesheet" href="./assets/style.css"/>
            <title>Tolkien to XML</title>
        </head>
    </xsl:variable>

    <!-- VARIABLE DU FOOTER -->
    <xsl:variable name="footer">
        <footer>
            <hr/>
            <div id="footer">
                <p>Site réalisé dans le cadre du cours de XSLT du Master TNAH de l'École nationale
                    des chartes.</p>
                <a href="https://www.chartes.psl.eu">
                    <img src="./img/logo_chartes.png" id="footer"/>
                </a>
            </div>
        </footer>
    </xsl:variable>


    <!-- VARIABLE DE LA NAVBAR -->
    <xsl:variable name="navbar">
        <div id="navbar">
            <ul>
                <li>
                    <a href="index.html">Accueil</a>
                </li>
                <!--<li><a href="extrait1.html">Les contes perdus</a></li>
               <li><a href="extrait2.html">Le Silmarillion</a></li>-->
                <xsl:for-each select="//body/div">
                    <xsl:variable name="numero-div" select="@n"/>
                    <li>
                        <a href="extrait{$numero-div}.html">Extrait n°<xsl:value-of
                                select="$numero-div"/> : <xsl:value-of
                                select="key('biblio', @source)/title"/>
                        </a>
                    </li>
                </xsl:for-each>
                <li>
                    <a href="toc.html">Index des noms</a>
                </li>
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
                    <h1>Les Légendes de la Terre du Milieu : construction d'un récit</h1>
                    <div>
                        <details>
                            <summary>
                                <h2>Présentation du corpus </h2>
                            </summary>

                            <p>Le but de ce projet est de présenter aux lecteurs francophones la
                                richesse de l'oeuvre littéraire de J.R.R. Tolkien.</p>

                            <p>Contrairement au <emph>Seigneur des Anneauxdes Anneaux</emph> et au
                                    <emph>Hobbit</emph>, romans achevés qui ont fait sa notoriété,
                                une grande partie de l'oeuvre de Tolkien est restée à l'état
                                d'ébauche. Son fils Christopher en a reconstitué une partie dans le
                                    <emph>Silmarillion</emph> (1977) et les <emph>Livre des Contes
                                    Perdus</emph> (1983-1984) : ces deux ouvrages témoignent de
                                plusieurs états de l'avancée de Tolkien dans la construction de son
                                univers.</p>

                            <p>Trois extraits tirés de ces deux ouvrages ont été retenus pour
                                témoigner de ce travail : ils relatent la création de Laurelin et
                                Silpion, deux arbres qui à la création de la Terre du Milieu
                                éclairent le pays de Valinor comme le Soleil et la Lune.</p>

                            <p>Le premier extrait, tiré du <emph>Livre des Contes Perdus</emph>, est
                                constitué des premières notes de Tolkien sur ce récit sur la
                                naissance des Deux Arbres du Valinor.</p>
                            <p>Le second extrait, tiré du Silmarillion, relate la naissance du
                                premier arbre. Le dernier extrait lui fait suite et raconte la
                                naissance du second arbre. Les deux textes du Silmarillion
                                témoignent d'un état plus achevé du récit..</p>
                        </details>

                        <details>
                            <summary>
                                <h2>Pourquoi le XML ?</h2>
                            </summary>
                            <p>L'encodage de ces textes en XML permet de les présenter de manière
                                structurée, et de mettre ainsi en regard les deux récits..</p>

                            <p>En organisant les éléments plus conceptuels de ces extraits, il est
                                ainsi possible de rattacher les noms de personnages, de races ou de
                                lieux à un identifiant spécifique et de mettre en valeur le travail
                                de recherche et de choix de nom de l'auteur. Chaque nom ou concept
                                créé par Tolkien a été lié à sa page correspondante sur le site du
                                    <a>Tolkien Gateway</a>..</p>

                            <p>Le modèle choisi pour structurer ces documents est très largement
                                inspiré des guidelines de la TEI.</p>
                        </details>

                    </div>
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
                        <xsl:copy-of select="$navbar"/>
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
                    <xsl:copy-of select="$navbar"/>
                    <h1>TITRE DE L'INDEX</h1>
                    <div>
                        <p>Description du site</p>
                    </div>
                </body>
                <xsl:copy-of select="$footer"/>
            </html>
        </xsl:result-document>
    </xsl:template>














</xsl:stylesheet>
