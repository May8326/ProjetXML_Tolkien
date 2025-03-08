<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">

    <xsl:output method="html"/>

    <!-- VARIABLE CONTENANT LES URL -->
    <xsl:variable name="tolkienGateway">https://tolkiengateway.net/wiki/Main_Page</xsl:variable>

    <!-- CLES DU FICHIER -->
    <xsl:key name="biblio" match="//bibl" use="@xml:id"/>
    <xsl:key name="paragraphes" match="body//p" use="generate-id()"/>
    <xsl:key name="noms-propres" match="body//*[contains(@ref, '')]" use="."/>
    <xsl:key name="refKey" match="*[@ref]" use="@ref"/>


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
            <div class="footer-container">
                <!-- Logo -->
                <div class="footer-logo">
                    <a href="https://www.chartes.psl.eu">
                        <img src="./img/logo_chartes.png" id="footer"/>
                    </a>
                </div>
                <!-- Index du site -->
               <div class="footer-nav">
                <ul>
                    <li>
                        <a href="index.html"><img src="./img/valinor-treesNB.png"/></a>
                    </li>
                    <li>
                        <a href="index.html">Accueil</a>
                    </li>
                    <xsl:for-each select="//body/div">
                        <xsl:variable name="numero-div" select="@n"/>
                        <li>
                            <a href="extrait{$numero-div}.html">
                                <xsl:value-of select="key('biblio', @source)/title"/>
                            </a>
                        </li>
                    </xsl:for-each>
                    <li>
                        <a href="toc.html">Index des noms</a>
                    </li>
                </ul></div>
                <!-- Mentions légales et crédits -->
                <div class="footer-bottom">
                    <p>&#169; 2025 Gioan Maëlys. Tous droits réservés.</p>
                    <p>Site réalisé dans le cadre du cours de XSLT du Master TNAH de l'École nationale
                        des chartes.</p>
                    <p>Ce site contient des textes protégés par droit d'auteur. Ceux-ci sont inclus uniquement à des fins d’étude et d’analyse dans le cadre d'un exercice académique. Aucune redistribution ou utilisation commerciale n'est autorisée pour ces textes sans l'autorisation des détenteurs des droits.</p>
                </div>
            </div>
        </footer>
    </xsl:variable>
        
       

    <!-- VARIABLE DE LA NAVBAR -->
    <xsl:variable name="navbar">
        <div id="navbar">
            <a href="index.html"><img src="./img/valinor-treesNB.png"/></a>
            <ul>
                <li>
                    <a href="index.html">Accueil</a>
                </li>
                <xsl:for-each select="//body/div">
                    <xsl:variable name="numero-div" select="@n"/>
                    <li>
                        <a href="extrait{$numero-div}.html">
                            <xsl:value-of select="key('biblio', @source)/title"/>
                        </a>
                    </li>
                </xsl:for-each>
                <li>
                    <a href="toc.html">Index des noms</a>
                </li>
            </ul>
        </div>
    </xsl:variable>
   
    
    <!-- TEMPLATE DU NUAGE DE MOTS -->
    <xsl:template name="nuage-de-mot">
        <div class="word-cloud">
            <!-- Sélectionner uniquement les éléments ayant @ref dans la div courante -->
            <xsl:for-each-group select=".//*[@ref]" group-by="@ref">
                <xsl:variable name="refValue" select="current-grouping-key()" />
                <xsl:variable name="nb_occurences" select="count(current-group())" />
                
                <!-- Déterminer la classe de taille -->
                <xsl:variable name="class_size" select="concat('word-', 
                    if ($nb_occurences &gt; 10) then 7
                    else if ($nb_occurences &gt; 8) then 6
                    else if ($nb_occurences &gt; 6) then 5
                    else if ($nb_occurences &gt; 4) then 4
                    else if ($nb_occurences &gt; 2) then 3
                    else if ($nb_occurences &gt; 1) then 2
                    else 1)" />
                
                <span class="word">
                    <a href="toc.html#{$refValue}" class="{$class_size}">
                        <xsl:value-of select="current-group()[1]/text()" />
                        (<xsl:value-of select="$nb_occurences" />)
                    </a>
                </span>
            </xsl:for-each-group>
        </div>
        <!-- Ajouter une légende -->
       
    </xsl:template>

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
                        <h2>Introduction</h2>
                        <details>
                            <summary>
                                <head>Présentation du corpus</head>
                            </summary>
                            <p>Le but de ce projet est de présenter aux lecteurs francophones la
                                richesse de l'oeuvre littéraire de J.R.R. Tolkien.</p>
                            <p>Contrairement au <cite>Seigneur des Anneaux</cite> et au
                                    <cite>Hobbit</cite>, romans achevés qui ont fait sa notoriété,
                                une grande partie de l'oeuvre de Tolkien est restée à l'état
                                d'ébauche. Son fils Christopher en a reconstitué une partie dans le
                                    <cite>Silmarillion</cite> (1977) et les <cite>Livre des Contes
                                    Perdus</cite> (1983-1984) : ces deux ouvrages témoignent de
                                plusieurs états de l'avancée de Tolkien dans la construction de son
                                univers.</p>

                            <p>Trois extraits tirés de ces deux ouvrages ont été retenus pour
                                témoigner de ce travail : ils relatent la création de Laurelin et
                                Silpion, deux arbres qui à la création de la Terre du Milieu
                                éclairent le pays de Valinor comme le Soleil et la Lune.</p>

                            <p>Le premier extrait, tiré du <cite>Livre des Contes Perdus</cite>, est
                                constitué des premières notes de Tolkien sur ce récit sur la
                                naissance des Deux Arbres du Valinor.</p>
                            <p>Le second extrait, tiré du Silmarillion, relate la naissance du
                                premier arbre. Le dernier extrait lui fait suite et raconte la
                                naissance du second arbre. Les deux textes du Silmarillion
                                témoignent d'un état plus achevé du récit..</p>
                        </details>

                        <details>
                            <summary>
                                <head>Pourquoi le XML ?</head>
                                
                            </summary>
                            <p>L'encodage de ces textes en XML permet de les présenter de manière
                                structurée, et de mettre ainsi en regard les deux récits.</p>
                            <p>En relevant les noms propres de ces extraits, il est
                                ainsi possible de rattacher les noms de personnages, de races ou de
                                lieux à un identifiant spécifique et de mettre en valeur le travail
                                de recherche et de choix des noms qu'a fait l'auteur. Chaque nom ou concept
                                créé par Tolkien a été lié à sa page correspondante sur le site du
                                    <a href="{$tolkienGateway}" target="_blank">Tolkien Gateway</a>..</p>

                            <p>Le modèle choisi pour structurer ces documents est très largement
                                inspiré des guidelines de la TEI.</p>
                        </details>

                    </div>
                    <h2>Vue des chapitres</h2>
                    <div class="view-panel">
                        
                        <ul>
                            <xsl:for-each select="//div">
                                <xsl:variable name="chapitre" select="@n"/>
                                <li>
                                    <a href="extrait{$chapitre}.html">Extrait n°<xsl:value-of
                                            select="$chapitre"/></a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                    <h3>Occurences des noms</h3>
                    <div class="view-panel">
                        <xsl:call-template name="nuage-de-mot"/>
                    </div>
                    
                    <h2>Bibliographie</h2>

                    <div class="view-panel">
                        <section id="bibliographie">
                            <xsl:for-each select="//sourceDesc/bibl">
                                <article>
                                    <xsl:value-of select="./author"/>, <em><xsl:value-of
                                            select="./title"/></em>, <xsl:value-of
                                        select="./editor[@resp = 'editor']"/> (éd.), <xsl:value-of
                                        select="./editor[@resp = 'translator']"/> (trad.),
                                        <xsl:value-of select="./pubPlace"/>, <xsl:value-of
                                        select="./publisher"/>, <xsl:value-of select="./date"/>,
                                        <em>pages <xsl:value-of select="./biblScope/@from"/> à
                                            <xsl:value-of select="./biblScope/@to"/></em>
                                </article>
                            </xsl:for-each>
                        </section>
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
                        <!-- pour mettre en H1 le titre du livre -->
                        <xsl:variable name="titre" select="key('biblio', @source)"/>
                        <h1>
                            <xsl:value-of select="$titre/title"/>
                        </h1>

                        <!-- Pour copier le texte de chaque paragraphe en extrait, et inclure un lien pour les noms propres -->
                        <div class="view-panel">
                            <xsl:for-each select="./p">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </div>
                        <h2>Nombre d'occurences des noms propres</h2>
                        <div class="view-panel">
                            <xsl:call-template name="nuage-de-mot"/>
                        </div>
                    </body>
                    <xsl:copy-of select="$footer"/>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="p">
        <p>
            <xsl:apply-templates select="node()"/>
        </p>
    </xsl:template>

    <!-- Template unique pour transformer les balises avec @ref en <a> -->
    <xsl:template match="*">
        <xsl:choose>
            <!-- Si l'élément a un attribut 'ref', on le transforme en balise <a> -->
            <xsl:when test="@ref">
                <a href="toc.html#{@ref}" target="_blank">
                    <xsl:apply-templates select="node()"/>
                </a>
            </xsl:when>

            <!-- Sinon, on copie l'élément tel quel -->
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- TEMPLATE DE L'INDEX DES NOMS -->

    <xsl:template name="toc">
        <xsl:result-document href="out/toc.html" indent="yes">
            <html>
                <xsl:copy-of select="$head"/>
                <body>
                    <xsl:copy-of select="$navbar"/>
                    <h1>Index des noms</h1>
                    <div class="index">
                        <h2>Noms de personnes</h2>
                        <table>
                            <thead>
                                <tr>
                                    <th>Nom</th>
                                    <th>Autres noms</th>
                                    <th>Note</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- LISTE DES NOMS DU TEXTE, GENEREE A PARTIR DU PROFILE DESC XML ET TRIEE PAR ORDRE ALPHABETIQUE -->
                                <xsl:for-each select="//profileDesc//person">
                                    <xsl:sort select="persName" order="ascending"/>
                                    <xsl:variable select="note/@source" name="lien"/>
                                    <tr id="{@xml:id}">
                                        <td>
                                            <a href="{$lien}" target="_blank">
                                                <xsl:value-of select="persName/text()"/>
                                            </a>
                                        </td>
                                        <td>
                                            <ul>
                                                <xsl:for-each select="persName/addName">
                                                  <li>
                                                  <xsl:value-of select="text()"/>
                                                  </li>
                                                </xsl:for-each>
                                            </ul>
                                        </td>
                                        <td>
                                            <xsl:copy-of select="note"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>

                            </tbody>
                        </table>


                    </div>

                    <div class="index">
                        <h2>Noms de Peuples</h2>

                        <table>
                            <thead>
                                <tr>
                                    <th>Nom</th>
                                    <th>Autres noms</th>
                                    <th>Note</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="//profileDesc//org">
                                    <xsl:sort select="orgName" order="ascending"/>
                                    <xsl:variable select="note/@source" name="lien"/>
                                    <tr id="{@xml:id}">
                                        <td>
                                            <a href="{$lien}" target="_blank">
                                                <xsl:value-of select="orgName/text()"/>
                                            </a>
                                        </td>
                                        <td>
                                            <ul>
                                                <xsl:for-each select="orgName/addName">
                                                  <li>
                                                  <xsl:value-of select="text()"/>
                                                  </li>
                                                </xsl:for-each>
                                            </ul>
                                        </td>
                                        <td>
                                            <xsl:copy-of select="note"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>

                            </tbody>
                        </table>

                    </div>

                    <div class="index">
                        <h2>Noms de Lieux</h2>

                        <table>
                            <thead>
                                <tr>
                                    <th>Nom</th>
                                    <th>Autres noms</th>
                                    <th>Note</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="//profileDesc//place">
                                    <xsl:sort select="geogName" order="ascending"/>
                                    <xsl:variable select="note/@source" name="lien"/>
                                    <tr id="{@xml:id}">
                                        <td>
                                            <a href="{$lien}" target="_blank">
                                                <xsl:value-of select="geogName/text()"/>
                                            </a>
                                        </td>
                                        <td>
                                            <ul>
                                                <xsl:for-each select="geogName/addName">
                                                  <li>
                                                  <xsl:value-of select="text()"/>
                                                  </li>
                                                </xsl:for-each>
                                            </ul>
                                        </td>
                                        <td>
                                            <xsl:copy-of select="note"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>

                            </tbody>
                        </table>

                    </div>
                                      
                </body>
                <xsl:copy-of select="$footer"/>
            </html>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
