<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">

    <xsl:output method="html"/>

    <!-- VARIABLE CONTENANT LES URL -->
    <xsl:variable name="tolkienGateway">https://tolkiengateway.net/wiki/Main_Page</xsl:variable>

    <!-- CLES DU FICHIER -->
    <xsl:key name="biblio" match="//bibl" use="@xml:id"/>
    <xsl:key name="paragraphes" match="body//p" use="generate-id()"/>
    <xsl:key name="noms-propres" match="body//*[contains(@ref, '')]" use="."/>
    <xsl:key name="refKey" match="*[@ref]" use="@ref" />
    
    
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
                <xsl:for-each select="//body/div">
                    <xsl:variable name="numero-div" select="@n"/>
                    <li>
                        <a href="extrait{$numero-div}.html"><xsl:value-of
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
                        <h2>Introduction</h2>
                        <details>
                            <summary>
                                <h3>Présentation du corpus </h3>
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
                                <h3>Pourquoi le XML ?</h3>
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
                    
                    <div class="view-panel">
                        <h3>Vue des chapitres</h3>
                        <ul>
                            <xsl:for-each select="//div">
                                <xsl:variable name="chapitre" select="@n"/>
                                <li><a href="extrait{$chapitre}.html">Extrait n°<xsl:value-of select="$chapitre"/></a></li>
                            </xsl:for-each>
                        </ul>
                    </div>
                    
                    <div class="view-panel">
                        <h3>Index des noms propres</h3>
                        <div class="word-cloud">
                        <!-- Sélectionner tous les éléments ayant un attribut @ref -->
                        <xsl:for-each select="//*[@ref]">
                            <!-- Créer une variable contenant la valeur de l'attribut @ref -->
                            <xsl:variable name="refValue" select="@ref" />
                            
                            <!-- Compter le nombre d'occurrences de chaque @ref distinct dans tout le document -->
                            <xsl:variable name="nb_occurences">
                                <xsl:value-of select="count(//*[@ref = $refValue])" />
                            </xsl:variable>
                            
                            <!-- Calculer la classe de taille en fonction du nombre d'occurrences -->
                            <xsl:variable name="class_size" select="concat('word-', 
                                if ($nb_occurences &gt; 10) then 7
                                else if ($nb_occurences &gt; 8) then 6
                                else if ($nb_occurences &gt; 6) then 5
                                else if ($nb_occurences &gt; 4) then 4
                                else if ($nb_occurences &gt; 2) then 3
                                else if ($nb_occurences &gt; 1) then 2
                                else 1)" />
                            
                            <!-- Afficher chaque @ref une seule fois avec la taille en fonction du nombre d'occurrences -->
                            <xsl:if test="generate-id() = generate-id(key('refKey', $refValue)[1])">
                                <span class="word">
                                    <a href="toc.html#{@ref}" class="{$class_size}"><xsl:value-of select="text()" /></a>
                                </span>
                            </xsl:if>
                        </xsl:for-each>
                    </div></div>
                  
                    
                    <div class="view-panel">
                        <h2>Bibliographie</h2>
                        <section id="bibliographie">
                            <xsl:for-each select="//sourceDesc/bibl">
                                <article>
                                    <xsl:value-of select="./author"/>, <em><xsl:value-of
                                            select="./title"/></em>, <xsl:value-of
                                        select="./editor[@resp='editor']"/> (éd.), <xsl:value-of
                                        select="./editor[@resp='translator']"/> (trad.), <xsl:value-of
                                        select="./pubPlace"/>, <xsl:value-of select="./publisher"/>,
                                        <xsl:value-of select="./date"/>, <em>pages <xsl:value-of
                                            select="./biblScope/@from"/> à <xsl:value-of
                                            select="./biblScope/@to"/></em>
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
                        <h1><xsl:value-of select="$titre/title"/></h1>
                        
                        <!-- Pour copier le texte de chaque paragraphe en extrait, et inclure un lien pour les noms propres -->
                        <div class="view-panel"><xsl:for-each select="./p">
                         <xsl:apply-templates select="."/>
                        </xsl:for-each></div>
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
                <a href="toc.html#{@ref}">
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
                                    <xsl:sort select="persName" order="ascending" />
                                    <xsl:variable select="note/@source" name="lien"/>
                                    <tr id="{@xml:id}">
                                        <td>
                                        <a href="{$lien}"><xsl:value-of select="persName/text()"/></a>
                                    </td>
                                    <td>
                                        <ul>
                                        <xsl:for-each select="persName/addName">
                                            <li><xsl:value-of select="text()"/></li>                                        
                                        </xsl:for-each>
                                        </ul>
                                    </td>
                                    <td>
                                        <xsl:copy-of select="note"></xsl:copy-of>
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
                                    <xsl:sort select="orgName" order="ascending" />
                                    <xsl:variable select="note/@source" name="lien"/>
                                    <tr id="{@xml:id}">
                                        <td>
                                            <a href="{$lien}"><xsl:value-of select="orgName/text()"/></a>
                                        </td>
                                        <td>
                                            <ul>
                                                <xsl:for-each select="orgName/addName">
                                                    <li><xsl:value-of select="text()"/></li>                                        
                                                </xsl:for-each>
                                            </ul>
                                        </td>
                                        <td>
                                            <xsl:copy-of select="note"></xsl:copy-of>
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
                                    <xsl:sort select="geogName" order="ascending" />
                                    <xsl:variable select="note/@source" name="lien"/>
                                    <tr id="{@xml:id}">
                                        <td>
                                            <a href="{$lien}"><xsl:value-of select="geogName/text()"/></a>
                                        </td>
                                        <td>
                                            <ul>
                                                <xsl:for-each select="geogName/addName">
                                                    <li><xsl:value-of select="text()"/></li>                                        
                                                </xsl:for-each>
                                            </ul>
                                        </td>
                                        <td>
                                            <xsl:copy-of select="note"></xsl:copy-of>
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
