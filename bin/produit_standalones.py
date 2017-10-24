"""

Petit script pour prendre chaque fichier .tex du dossier PS/, le compiler tout 
seul et le ranger dans le dossier standalones.

A executer depuis la racine du projet github

"""

source_tex = r"""

\documentclass{standalone}

\input{../sty_files/packages.sty}
\input{../sty_files/macros.sty}

\begin{document}

\input{../CHEMIN}

\end{document}

"""


import glob
import os
import subprocess

fichiers = glob.glob('PS/*.tex')

os.chdir('standalones')
# D'abord l'ecriture des fichiers TeX
FICHIERS_TEX = []
for fichier in fichiers:
    PS,nom = fichier.split('/') 
    fichier_tex = 'standalone_'+nom
    f = open(fichier_tex,'w')
    f.write(source_tex.replace('CHEMIN',fichier))
    f.close()
    FICHIERS_TEX.append(fichier_tex)

# Puis l'execution
#for fichier_tex in FICHIERS_TEX:
#    subprocess.call(['pdflatex',fichier_tex])
#    subprocess.call(['pdflatex',fichier_tex])
    
