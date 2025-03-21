# Dossier de l'exercice de XSLT

Les trois fichiers XML réalisés dans le cadre du cours de XML ont été fusionnés en un seul fichier [Corpus_Tolkien_all.xml](https://github.com/May8326/ProjetXML_Tolkien/blob/master/XML/transfo-xslt/Corpus_Tolkien_all.xml) pour les besoins de l'exercice.

Transformation réalisée en XSLT 2.0 avec Saxon-PE 12.3.

La conversion du fichier [Corpus_Tolkien_all.xml](https://github.com/May8326/ProjetXML_Tolkien/blob/master/XML/transfo-xslt/Corpus_Tolkien_all.xml) avec [Tolkien_to_html.xsl](https://github.com/May8326/ProjetXML_Tolkien/blob/master/XML/transfo-xslt/Tolkien_to_html.xsl) génère en racine du dossier 'out' l'ensemble des fichiers du site.

Les fichiers complémentaires appelés par la feuille de transformation xslt y sont déjà placés (images, css).

## Arborescence du dossier `out/`

out/

├── assets

│   └── [style.css](out/assets/style.css)

├── img

│   ├── [logo_chartes.png](out/img/logo_chartes.png)

│   ├── [valinor-trees.png](out/img/valinor-trees.png)

│   └── [valinor-treesNB.png](out/img/valinor-treesNB.png)

├── ... fichiers générés par xslt



