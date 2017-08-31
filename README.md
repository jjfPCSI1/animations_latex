# Animations en LaTeX

Ce projet a pour but de partager quelques animations LaTeX pour illustrer les 
cours de première année de CPGE. Il rassemble quelques dessins en TikZ (dont 
certains sont originaires du site physagreg.fr) adaptés pour être animés.

ATTENTION: le package animate utilise certaines invocations de magie noire que 
seul Acrobat Reader est capable de correctement rendre à l'écran. Il faut donc 
forcément l'installer pour visualiser les animations correspondantes.

# Utilisation

Ne pas oublier de compiler deux fois pour voir le résultat s'animer dans Acrobat Reader

Le fichier minimaliste.tex permet de tester les animations dans un cadre 
minimal qui devrait être présent dans toute distribution LaTeX.

Le fichier complet.tex rassemble quand à lui l'ensemble des animations 
classées en fonction du cours associé (il met bien plus longtemps à 
compiler...)

Le document poly_lentilles.pdf est conçu pour être distribué aux élèves (4 
pages par 4 pages, imprimé en recto-verso) pour que ceux-ci puissent vérifier 
leurs constructions. La version pdf devrait leur permettre de visualiser la 
construction au fur et à mesure du tracé des rayons en partant soit de 
l'objet, soit de l'image. Les scripts (en Ruby) qui ont permit sa fabrication 
sont présents dans le répertoire bin/

# Remarques

Malheureusement, pour que l'animation fonctionne, il faut forcément qu'elle 
soit compilée dans le document et non incluse à l'aide d'un \includegraphics 
ou autre. La compilation est donc bien plus lente, d'où la nécessité d'un 
fichier minimal qui permettra de préparer l'animation sans que toutes les 
autres ne soient recompilées au passage.


