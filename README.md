# Animations en LaTeX

Ce projet a pour but de partager quelques animations LaTeX pour illustrer les 
cours de premi�re ann�e de CPGE. Il rassemble quelques dessins en TikZ (dont 
certains sont originaires du site physagreg.fr) adapt�s pour �tre anim�s.

ATTENTION: le package animate utilise certaines invocations de magie noire que 
seul Acrobat Reader est capable de correctement rendre � l'�cran. Il faut donc 
forc�ment l'installer pour visualiser les animations correspondantes.

# Utilisation

Ne pas oublier de compiler deux fois pour voir le r�sultat s'animer dans Acrobat Reader

Le fichier minimaliste.tex permet de tester les animations dans un cadre 
minimal qui devrait �tre pr�sent dans toute distribution LaTeX.

Le fichier complet.tex rassemble quand � lui l'ensemble des animations 
class�es en fonction du cours associ� (il met bien plus longtemps � 
compiler...)

# Remarques

Malheureusement, pour que l'animation fonctionne, il faut forc�ment qu'elle 
soit compil�e dans le document et non incluse � l'aide d'un \includegraphics 
ou autre. La compilation est donc bien plus lente, d'o� la n�cessit� d'un 
fichier minimal qui permettra de pr�parer l'animation sans que toutes les 
autres ne soient recompil�es au passage.


