#coding: latin1

"""
Afin de generer les differentes animations pour aller du spatial au temporel
"""


base_latex = r""" 

\def\droite{DROITE}
\def\cas{CAS}
\def\spatial{SPATIAL}
\ifthenelse{\spatial=1}{
On donne le profil spatial d'une onde à $t=0$ sous la forme $y(x,t=0)=f(x)$. 
}{
On donne l'évolution temporelle d'une onde en $x=0$ sous la forme $y(x=0,t)=f(t)$. 
}
On suppose que cette onde se déplace sans déformation vers la \ifthenelse{\droite=1}{droite}{gauche} à célérité constante $c$.
\begin{enumerate}
\ifthenelse{\spatial=1}{
	\item	Quelle est l'expression mathématique de $y(x,t)$ à tout instant $t$ ultérieur ?
			$\boxed{y(x,t) = f(x\ifthenelse{\droite=1}{-}{+}ct)}$ % CORRIGE
	\item	Dessiner le profil aux instants $t_1>0$ et $t_2>t_1$.
			$t_1$ en rouge et $t_2$ en bleu. % CORRIGE
	\item	Retrouver l'évolution temporelle future aux points $x=0$, 
			$x_1\ifthenelse{\cas=1}{>}{<}0$ et $x_2\ifthenelse{\cas=1}{>}{<}x_1$.
			$x=0$ en gris, $x_1$ en vert et $x_2$ en violet. % CORRIGE
}{
	\item	Quel est l'expression mathématique de $y(x,t)$ pour toute abscisse $x$ de la corde ?
			$\boxed{y(x,t) = f(t\ifthenelse{\droite=1}{-}{+}x/c)}$ % CORRIGE
	\item	Dessiner l'évolution temporelle future aux points $x_1\ifthenelse{\cas=1}{>}{<}0$ et $x_2\ifthenelse{\cas=1}{>}{<}x_1$.
			$x=0$ en gris, $x_1$ en vert et $x_2$ en violet. % CORRIGE
	\item	Retrouver le profil spatial de la corde aux instants $t_1>0$ et $t_2>t_1$.
			$t_1$ en rouge et $t_2$ en bleu. % CORRIGE
}
\end{enumerate}

% ENONCE \def\icompteur{0}

\begin{animateinline}[autoplay,loop,controls,poster=last]{2}  % CORRIGE
    \multiframe{30}{icompteur=00+2}{              % CORRIGE
        \begin{tikzpicture}[declare function={
        onde(\x) = sin(8*\x*180.0/pi+PHI) * exp(-1.6*(\x)*(\x)) ;
        },scale=0.83]
        \pgfmathsetmacro{\c}{\droite*0.5}
        \pgfmathsetmacro{\TUN}{20}
        \pgfmathsetmacro{\TDEUX}{40}
        \pgfmathsetmacro{\XUN}{\cas*1}
        \pgfmathsetmacro{\XDEUX}{\cas*2}
        \draw [->] (-5,0) -- (5,0) node [below] {$x$} ;
        \draw [->] (0,-2) -- (0,2) node [right] {Profil spatial} ;
        \ifthenelse{\spatial=1}{
        \draw [thick,smooth,samples=100,domain=-4.5:4.5] 
        plot (\x,{onde(\x-\c*\icompteur*0.1)}) ;
        }{
        \ifthenelse{\icompteur>0}{
        \draw [thick,smooth,samples=100,domain=-4.5:4.5] 
        plot (\x,{onde(\x-\c*\icompteur*0.1)}) ;
        }{}
        }
        \draw [help lines,thick,smooth,samples=100,domain=-4.5:4.5] % CORRIGE
        plot (\x,{onde(\x)}) ;                                      % CORRIGE
        \ifthenelse{{\icompteur>\TUN-1}}{							% CORRIGE
        \draw [red,thick,smooth,samples=100,domain=-4.5:4.5]        % CORRIGE
        plot (\x,{onde(\x-\c*\TUN*0.1)}) ;                          % CORRIGE
        }{}															% CORRIGE
        \ifthenelse{{\icompteur>\TDEUX-1}}{							% CORRIGE
        \draw [blue,thick,smooth,samples=100,domain=-4.5:4.5] 		% CORRIGE
        plot (\x,{onde(\x-\c*\TDEUX*0.1)}) ;						% CORRIGE
        }{}															% CORRIGE
        \filldraw [help lines] (0,{onde(0-\c*\icompteur*0.1)})        circle (1pt) node [below] {$x=0$};	% CORRIGE
        \filldraw [green] ({\XUN}  ,{onde(\XUN-\c*\icompteur*0.1)})   circle (1pt) node [below] {$x_1$};	% CORRIGE
        \filldraw [violet]({\XDEUX},{onde(\XDEUX-\c*\icompteur*0.1)}) circle (1pt) node [below] {$x_2$};	% CORRIGE
        \ifthenelse{\spatial=1}{\pgfmathsetmacro{\depart}{0}}{\pgfmathsetmacro{\depart}{-6}}
        \pgfmathsetmacro{\XSHIFT}{6-\depart}
        \begin{scope}[xshift={\XSHIFT cm}]
           \draw [->] (\depart,0) -- (6,0) node [below] {$t$};
           \draw [->] (0,-2) -- (0,2) node [right] {Évolution temporelle};
           \draw [help lines,thick,smooth,samples={-10*\depart + 2*\icompteur+2},	% CORRIGE
           domain=\depart:{(\icompteur)*0.1}]								% CORRIGE
           plot(\x,{onde(0-\c*\x)}) ;								% CORRIGE
           \draw [green,thick,smooth,samples={-10*\depart + 2*\icompteur+2},		% CORRIGE
           domain=\depart:{\icompteur*0.1}]								% CORRIGE
           plot(\x,{onde(\XUN-\c*\x)}) ;							% CORRIGE
           \draw [violet,thick,smooth,samples={-10*\depart + 2*\icompteur+2},		% CORRIGE
           domain=\depart:{\icompteur*0.1}]								% CORRIGE
           plot(\x,{onde(\XDEUX-\c*\x)}) ;							% CORRIGE
           \ifthenelse{\spatial=1}{}{
           \draw [thick,smooth,samples={2*60+2},	
           domain=-6:{(60)*0.1}]								
           plot(\x,{onde(0-\c*\x)}) ;								
           }
           \filldraw [red] ({\TUN*0.1},0) circle (1pt) node [below] {$t_1$} ;
           \filldraw [blue]({\TDEUX*0.1},0) circle (1pt) node [below] {$t_2$};
        \end{scope}
        \end{tikzpicture}
    }               % CORRIGE
\end{animateinline} % CORRIGE
"""

DICO = {'spatial':'1', 'temporel':'-1','cas1':'1','cas2':'-1','droite':'1','gauche':'-1'}



i = 0
FICHIERS = []
for sp in ['spatial','temporel']:
    for c in ['cas1','cas2']:
        for doug in ['droite','gauche']:
            for coue in ['corrige','enonce']:
                phi = str((i*30 + 10)%360)
                fichier = 'PS/animation_{}_{}_{}_{}_{}deg.tex'.format(sp,doug,c,coue,phi)
                f = open(fichier,'w')
                for line in base_latex.splitlines():
                    line = line.replace('DROITE',DICO[doug])
                    line = line.replace('PHI',phi)
                    line = line.replace('CAS',DICO[c])
                    line = line.replace('SPATIAL',DICO[sp])
                    if coue != 'corrige':
                        if line.count('CORRIGE') > 0: line = ''
                        line = line.replace('% ENONCE','')
                    f.write(line+"\n")
                f.close()
                if coue == 'enonce': 
                    i += 1
                    FICHIERS.append(fichier)

print(FICHIERS)

squelette = r"""\documentclass{article}

\input{sty_files/packages.sty}
\input{sty_files/macros.sty}

\usepackage{vmargin}
\setmarginsrb{10mm}{10mm}{10mm}{5mm}{12pt}{11mm}{0pt}{11mm}

\begin{document}

"""
tex_file = squelette
for i in range(4):
    s = ''
    for j in range(2):
        s += '\\vfil\n\n\\input{{{}}}\n\n'.format(FICHIERS[2*i+j])
    s = s + "\\newpage\n\n" + s.replace('enonce','corrige') + "\\newpage\n\n"
    tex_file += s

tex_file += '\\end{document}'

f = open('total_spatial_temporel.tex','w')
f.write(tex_file)
f.close()
