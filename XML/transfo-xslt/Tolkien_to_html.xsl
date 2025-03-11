<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">

    <xsl:output method="html"/>

    <!-- ............... -->
    <!-- CLES DU FICHIER -->
    <!-- ............... -->
    <!-- clé pour rattacher chaque div à sa source en biblio -->
    <xsl:key name="biblio" match="//bibl" use="@xml:id"/>
    <!-- clé pour générer un id unique à chaque paragraphe et éviter les répétitions quand je crée des liens pour les noms propres -->
    <xsl:key name="paragraphes" match="body//p" use="generate-id()"/>
    <!-- clés pour sélectionner les noms propres du texte -->
    <xsl:key name="noms-propres" match="body//*[contains(@ref, '')]" use="."/>
    <xsl:key name="refKey" match="*[@ref]" use="@ref"/>

    <!-- ................................. -->
    <!-- VARIABLE DU HEAD DU DOCUMENT HTML -->
    <!-- ................................. -->
    <xsl:variable name="head">
        <head>
            <meta charset="UTF-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
            <link rel="stylesheet" href="./assets/style.css"/>
            <link rel="icon" type="image/x-icon" href="./img/valinor-treesNB.png"/>
            <title>Tolkien to XML</title>
        </head>
    </xsl:variable>

    <!-- .................. -->
    <!-- VARIABLE DU FOOTER -->
    <!-- .................. -->
    <xsl:variable name="footer">
        <footer>
            <div class="footer-container">
                <!-- Logo du footer -->
                <div class="footer-logo">
                    <a href="https://www.chartes.psl.eu"><img src="./img/logo_chartes.png" id="footer" alt="enc-logo"/></a>
                </div>
                <!-- Navigation du site -->
                <div class="footer-nav">
                    <ul>
                        <li><a href="index.html"><img src="./img/valinor-treesNB.png" alt="logo du site"/></a></li>
                        <li><a href="index.html">Accueil</a></li>
                        <!-- Index généré pour les pages de chapitre -->
                        <xsl:for-each select="//body/div">
                            <xsl:variable name="numero-div" select="@n"/>
                            <li><a href="extrait{$numero-div}.html"><xsl:value-of select="key('biblio', @source)/title"/></a></li>
                        </xsl:for-each>
                        <li><a href="toc.html">Index des noms</a></li>
                    </ul>
                </div>
                <!-- Mentions légales et crédits -->
                <div class="footer-bottom">
                    <p>&#169; 2025 Gioan Maëlys. Tous droits réservés.</p>
                    <p>Site réalisé dans le cadre du cours de XSLT du Master TNAH de l'École nationale des chartes.</p>
                    <p>Ce site contient des textes protégés par droit d'auteur. Ceux-ci sont inclus uniquement à des fins d’étude et d’analyse dans le cadre d'un exercice académique. Aucune redistribution ou utilisation commerciale n'est autorisée pour ces textes sans l'autorisation des détenteurs des droits.</p>
                </div>
            </div>
        </footer>
    </xsl:variable>

    <!-- ..................... -->
    <!-- VARIABLE DE LA NAVBAR -->
    <!-- ..................... -->
    <xsl:variable name="navbar">
        <header>
            <nav id="navbar">
                <!-- logo du site -->
                <a href="index.html"><img src="./img/valinor-treesNB.png" alt="logo du site"/></a>
                <!-- Navigation -->
                <ul>
                   <li><a href="index.html">Accueil</a></li>
                    <!-- Index généré pour les pages de chapitre -->
                    <xsl:for-each select="//body/div">
                        <xsl:variable name="numero-div" select="@n"/>
                        <li><a href="extrait{$numero-div}.html"><xsl:value-of select="key('biblio', @source)/title"/></a></li>
                    </xsl:for-each>
                    <li><a href="toc.html">Index des noms</a></li>
                </ul>
            </nav>
        </header>
    </xsl:variable>

    <!-- ......................... -->
    <!-- TEMPLATE DU NUAGE DE MOTS -->
    <!-- ......................... -->
    <xsl:template name="nuage-de-mot">
        <div class="word-cloud">
            <!-- Pour Sélectionner uniquement les éléments qui ont l'attribut @ref dans la div sélectionnée, grâce à la clé en début de fichier -->
            <xsl:for-each-group select=".//*[@ref]" group-by="@ref">
                <!-- Pour chaque groupe du même nom propre avec le même attribut @ref, création d'une variable pour stocker @ref  -->
                <xsl:variable name="refValue" select="current-grouping-key()"/>
                <!-- Variable pour stocker le nombre d'éléments dans le groupe actuel qui ont la même valeur que @ref -->
                <xsl:variable name="nb_occurences" select="count(current-group())"/>

                <!-- Déterminer la classe css du mot selon son nombre d'occurences -->
                <xsl:variable name="class_size" select="concat('word-',
                        if ($nb_occurences &gt; 10) then 7 else
                        if ($nb_occurences &gt; 8) then 6 else
                        if ($nb_occurences &gt; 6) then 5 else
                        if ($nb_occurences &gt; 4) then 4 else
                        if ($nb_occurences &gt; 2) then 3 else
                        if ($nb_occurences &gt; 1) then 2 else 1)"/>
                       
                <!-- Affichage du nuage de mots -->
                <span class="word">
                <!-- Le mot avec un lien vers la page d'index et sa classe css pour gérer taille et couleur -->
                    <a href="toc.html#{$refValue}" class="{$class_size}">
                    <!-- Pour mettre le nombre d'occurrences entre parenthèses après le mot -->
                        <xsl:value-of select="current-group()[1]/text()"/> (<xsl:value-of select="$nb_occurences"/>) 
                    </a>
                </span>
            </xsl:for-each-group>
        </div>
    </xsl:template>

    <!-- ........................................................... -->
    <!-- TEMPLATE QUI MATCHE LA RACINE ET APPELLE LES TEMPLATES HTML -->
    <!-- ........................................................... -->
    <xsl:template match="/">
        <xsl:call-template name="index"/>
        <xsl:call-template name="extraits"/>
        <xsl:call-template name="toc"/>
    </xsl:template>


    <!-- ....................................................................... -->
    <!-- AVANT DE COMMENCER : ...................................................-->
    <!-- DEUX TEMPLATES POUR CONVERTIR LE CONTENU DES PARAGRAPHES EN HTML VALIDE -->
    <!-- ....................................................................... -->

    <!-- pour sélectionner les balises enfants des paragraphes -->
    <xsl:template match="p">
        <p>
            <xsl:apply-templates select="node()"/>
        </p>
    </xsl:template>

    <!-- pour transformer les balises TEI de l'intérieur des paragraphes en HTML valide -->
    <xsl:template match="*">
        <xsl:choose>
            <!-- POUR L'INTRODUCTION : si la balise est un <emph>, la remplace en <cite> -->
            <xsl:when test="self::emph">
                <cite>
                    <xsl:apply-templates select="node()"/>
                </cite>
            </xsl:when>
            <!-- si la balise est un <ref target="xyz">, la remplace en <a href="xyz" -->
            <xsl:when test="self::ref">
                <a href="{@target}" target="_blank">
                    <xsl:apply-templates select="node()"/>
                </a>
            </xsl:when>
            <!-- POUR LES EXTRAITS : Si l'élément a un attribut 'ref', je le transforme en balise <a> -->
            <xsl:when test="@ref">
                <a href="toc.html#{@ref}" target="_blank">
                    <xsl:apply-templates select="node()"/>
                </a>
            </xsl:when>
            <!-- Si c'est un élément <date>, je l'ignore -->
            <xsl:when test="self::date">
                    <xsl:apply-templates select="node()"/>
            </xsl:when>
            <!-- si c'est un élément <gap>, je le remplace par [...] -->
            <xsl:when test="self::gap">
                [...]
            </xsl:when>
            <!-- Si c'est un élément de citation, je le met dans la balise <q> -->
            <xsl:when test="self::q">
                <q>
                    <xsl:apply-templates select="node()"></xsl:apply-templates>
                </q>
            </xsl:when>
            <!-- Sinon, je copie l'élément tel quel -->
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ......................... -->
    <!-- GENERER LA PAGE D'ACCUEIL -->
    <!-- ......................... -->
    <xsl:template name="index">
        <!-- creation de la page html  -->
        <xsl:result-document href="out/index.html" indent="yes">
            <html>
                <!-- intégration de la variable head -->
                <xsl:copy-of select="$head"/>
                <body>
                    <!-- intégration de la variable navbar -->
                    <xsl:copy-of select="$navbar"/>
                    <!-- Introduction du projet dans des boîtes interactives (texte du github) -->
                    <main>
                    <h1>Les Légendes de la Terre du Milieu : construction d'un récit</h1>
                    <div>
                        <h2>Introduction</h2>
                        <details>
                            <summary>
                                Présentation du corpus
                            </summary>
                            <!-- copie des premiers paragraphes du projectDesc du document tei -->
                            <xsl:for-each select="//projectDesc/p[position() &gt;= 2 and position() &lt;= 6]">
                                <!-- appelle la template créée pour les paragraphes -->
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </details>
                        <details>
                            <summary>
                                Pourquoi le XML ?
                            </summary>
                            <!-- copie des derniers paragraphes du projectDesc du document tei -->
                            <xsl:for-each select="//projectDesc/p[position() &gt; 6]">
                                <!-- appelle la template créée pour les paragraphes -->
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                            </details>
                    </div>
                    <!-- lien vers les deux extraits -->
                    <h2>Vue des chapitres</h2>
                    <div class="view-panel">
                        <ul>
                            <xsl:for-each select="//div">
                                <xsl:variable name="chapitre" select="@n"/>
                                <li><a href="extrait{$chapitre}.html">Extrait n°<xsl:value-of select="$chapitre"/></a></li>
                            </xsl:for-each>
                        </ul>
                    </div>
                    <!-- Intégration du nuage de mot comptant les noms propres de tout les extraits -->
                    <h3>Occurences des noms</h3>
                    <div class="view-panel">
                        <xsl:call-template name="nuage-de-mot"/>
                    </div>
                    <!-- Bibliographie générée à partir de l'entête TEI -->
                    <h2>Bibliographie</h2>
                    <div class="view-panel">
                        <section id="bibliographie">
                        <h3>Sources des textes</h3>
                        <ul>
                            <xsl:for-each select="//sourceDesc/bibl">
                                <li>
                                    <xsl:value-of select="./author"/>, 
                                    <em><xsl:value-of select="./title"/></em>,
                                    <xsl:value-of select="./editor[@resp = 'editor']"/> (éd.), 
                                    <xsl:value-of select="./editor[@resp = 'translator']"/> (trad.), 
                                    <xsl:value-of select="./publisher"/>, 
                                    <xsl:value-of select="./pubPlace"/>,
                                    <xsl:value-of select="./date"/>,
                                    <em>pages <xsl:value-of select="./biblScope/@from"/> à
                                    <xsl:value-of select="./biblScope/@to"/></em>
                                </li>
                            </xsl:for-each>
                        </ul>
                        <h3>Source complémentaire</h3>
                            <ul>
                                <li>John Ronald Reuel Tolkien, <em>Le livre des contes perdus. Première partie</em>, Christopher Tolkien (éd.), Adam Tolkien (trad.), Christian Bourgeois, Paris, 1995, pages 122-123</li>    
                            </ul>
                        </section>
                    </div>
                    </main>
                    <xsl:copy-of select="$footer"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <!-- ............................ -->
    <!-- GENERER LES PAGES D'EXTRAITS -->
    <!-- ............................ -->
    <xsl:template name="extraits">
        <xsl:for-each select="//body/div">
            <!-- document de sortie -->
            <xsl:result-document href="{concat('out/', 'extrait', @n, '.html')}" indent="yes">
                <html>
                    <xsl:copy-of select="$head"/>
                    <body>
                        <xsl:copy-of select="$navbar"/>
                        <main>
                            <!-- Met en H1 le titre du livre, qu'il va cherche en rattachant la div à sa source en biblio grâce à l'attribut @source -->
                          <xsl:variable name="titre" select="key('biblio', @source)"/>
                            <h1><xsl:value-of select="$titre/title"/></h1>
                          <!-- Copie le texte de chaque paragraphe en convertissant chaque balise tei en html valide -->
                           <div class="view-panel">
                              <xsl:for-each select="./p">
                                  <!-- appelle la template créée plus bas pour les paragraphes -->
                                  <xsl:apply-templates select="."/>
                              </xsl:for-each>
                          </div>
                         <!-- Intègre un nuage de mots qui compte les noms propres de cette div -->
                            <h2>Nombre d'occurences des noms propres</h2>
                            <div class="view-panel">
                                <xsl:call-template name="nuage-de-mot"/>
                            </div>
                        </main>
                        <xsl:copy-of select="$footer"/>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>


    <!-- ................................................. -->
    <!-- TEMPLATE DE TABLEAU POUR LA PAGE D'INDEX DES NOMS -->
    <!-- ................................................. -->
    <xsl:template name="table-index">
        <xsl:param name="element"/>
        <xsl:param name="name"/>
        <table>
            <thead>
                <tr>
                    <th>Nom</th>
                    <th>Autres noms</th>
                    <th>Note</th>
                </tr>
            </thead>
            <tbody>
                <!-- liste des noms du texte, générée à partir du profiledesc tei et triee par ordre alphabetique -->
                <!-- utilisation de name() pour que la string des paramètres soit considérée comme un nom d'élément par le XPath -->
                <xsl:for-each select="//profileDesc//*[name() = $element]">
                    <xsl:sort select="*[name() = $name]" order="ascending"/>
                    <!--  crée une variable pour stocker le lien vers le TolkienGateway associé au nom dans le profiledesc -->
                    <xsl:variable name="lien" select="note/@source"/>
                    <tr id="{@xml:id}">
                        <!-- crée une colonne pour les noms avec le lien vers le TolkienGateway -->
                        <td>
                            <a href="{$lien}" target="_blank">
                                <xsl:value-of select="*[name() = $name]/text()"/>
                            </a>
                        </td>
                        <!-- crée une colonne pour les alias -->
                        <td>
                            <ul>
                                <xsl:for-each select="*[name() = $name]/addName">
                                    <li>
                                        <xsl:value-of select="text()"/>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </td>
                        <!-- crée une colonne pour les commentaires -->
                        <td>
                            <xsl:for-each select="./note/p">
                                <!-- appelle la template créée plus bas pour les paragraphes -->
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>

    <!-- ................................ -->
    <!-- GENERER LA PAGE D'INDEX DES NOMS -->
    <!-- ................................ -->
    <xsl:template name="toc">
        <!-- document de sortie -->
        <xsl:result-document href="out/toc.html" indent="yes">
            <html>
                <xsl:copy-of select="$head"/>
                <body>
                    <xsl:copy-of select="$navbar"/>
                    <main>
                        <!-- Génère trois tableaux pour les noms, les lieux et les peuples en précisant en paramètre les éléments à partir desquels sont faits les tableaux -->
                        <h1>Index des noms</h1>
                        <div class="index">
                            <h2>Noms de personnes</h2>
                            <xsl:call-template name="table-index">
                                <xsl:with-param name="element" select="'person'"/>
                                <xsl:with-param name="name" select="'persName'"/>
                            </xsl:call-template>
                       </div>
                        <div class="index">
                            <h2>Noms de Peuples</h2>
                            <xsl:call-template name="table-index">
                                <xsl:with-param name="element" select="'org'"/>
                                <xsl:with-param name="name" select="'orgName'"/>
                            </xsl:call-template>
                       </div>
                        <div class="index">
                            <h2>Noms de Lieux</h2>
                            <xsl:call-template name="table-index">
                                <xsl:with-param name="element" select="'place'"/>
                                <xsl:with-param name="name" select="'geogName'"/>
                            </xsl:call-template>
                        </div>
                    </main>
                    <xsl:copy-of select="$footer"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
