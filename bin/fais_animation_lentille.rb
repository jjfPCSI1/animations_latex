#!/usr/bin/ruby -w
##################################################
# == Synopsis
# 
# Cree automatiquement un fichier TikZ avec lentille + objet/image et son corrige
# Demande l'usage du package {animate} et AcrobatReader pour voir l'animation proprement dite
# 
# NB: la partie miroir n'a pas ete mise a jour car non necessaire depuis la 
# reforme mais reste presente dans le code
# 
# == Usage
# run
#    fais_animation_lentille.rb  --help
# to find out
# 
# == History
# 18/10/2012  Creation
# 28/08/2017  Adaptation pour animation automatique
# 
# == Author
# Fleck Jean-Julien
# 
# == Copyright
# Copyright (c) Fleck Jean-Julien
# Licenced under the same terms as Ruby
# 
##################################################

##################################################
## Main class description
##################################################

class FaisSchemaLentilleOuMiroir
  require 'rubygems'
  require 'optparse'
  require 'ostruct'
  include Math

  ##################################################
  ## Initialization routine
  ##################################################

  def initialize
    @options = OpenStruct.new
  end

  ##################################################
  ## Pour obtenir la position de l'image
  ##################################################

  def image(p,fp)
    if o.lentille  ## Cas des lentilles
      return 10000 if p == -fp
      return p*fp/(p+fp) 
    else           ## Cas des miroirs
      return 10000 if p == -fp
      return p*(-fp)/(p+fp)
    end
  end

  ##################################################
  ## Pour obtenir la position de l'objet
  ##################################################

  def objet(pp,fp)
    if o.lentille  ## Cas des lentilles
      return -10000 if pp == fp
      return pp*fp/(fp-pp) 
    else           ## Cas des miroirs
      return -10000 if pp == -fp
      return pp*(-fp)/(pp+fp)
    end
  end

  ##################################################
  ## Options reading routine
  ##################################################

  def read_options
    ## Options default values
    o.lentille = true
    o.fp = 3.0
    o.p  =-6.0
    o.pp = image(o.p,o.fp)
    o.AB = 2.0
    o.ApBp = o.pp/o.p*o.AB
    o.ltype = "LC"
    o.otype = "O#{o.p}"
    o.reverse = false
    
    opts = OptionParser.new do |opts|
      opts.banner = "Usage: fais_schema_lentille_ou_miroir.rb [options]"
      opts.banner = "ATTENTION: BIEN UTILISER LES OPTIONS -l ET -m EN PREMIER !"
      opts.separator "Available options:"
      opts.on("-l", "--lentille FOCALE",
              "Cas des lentilles (cas par defaut) [#{o.fp}]") do |fp|
        o.lentille = true
        o.fp = Float(fp)
        o.pp = image(o.p,o.fp)
        o.ApBp = o.pp/o.p*o.AB
        o.ltype = o.fp>0 ? "LC" : "LD"
      end
      opts.on("-m", "--miroir FOCALE (non fonctionnel)",
              "Cas des miroirs") do |fp|
        o.lentille = false
        puts opts ; exit
        o.fp = Float(fp)
        o.pp = image(o.p,o.fp)
        o.ApBp = -o.pp/o.p*o.AB
        o.ltype = o.fp>0 ? "MC" : "MD"
      end
      opts.on("-o","--objet P,AB", "Position et taille de l'objet voulu", "[#{o.p},#{o.AB}]") do |obj|
        o.p,o.AB = obj.split(/,/).map{|e| Float(e)}
        o.pp  = image(o.p,o.fp)
        o.ApBp = o.pp/o.p*o.AB
        o.ApBp*= -1 unless o.lentille
        o.otype = "O#{o.p}"
      end
      opts.on("-i","--image P',A'B'", "Position et taille de l'image voulue", "[#{o.pp},#{o.ApBp}]") do |image|
        o.pp,o.ApBp = image.split(/,/).map{|e| Float(e)}
        o.p  = objet(o.pp,o.fp)
        o.reverse = true
        o.AB = o.p/o.pp*o.ApBp
        o.AB*= -1 unless o.lentille
        o.otype = "I#{o.pp}"
      end
      opts.on_tail("-h","--help","This help message") {puts opts; exit}
      opts.parse!(ARGV)
    end
    o.fpsign = o.fp.abs/o.fp
    o.basename = o.ltype + o.otype

  end

  ##################################################
  ## Talking to @options
  ##################################################

  def o
    @options
  end

  ##################################################
  ## Le Preambule du dessin
  ##################################################

  TRUE_PREAMBLE = ''
  
  HAUTEUR = 4
  
  LARGEUR = 8
  
  PREAMBLE = TRUE_PREAMBLE + "
  
  \\begin{tikzpicture}[scale=0.5]
    \\clip (-#{LARGEUR+1},-#{HAUTEUR+1}) rectangle (#{LARGEUR+1},#{HAUTEUR+1}) ;
    \\draw [help lines] (-#{LARGEUR},-#{HAUTEUR}) grid [step=1] (#{LARGEUR},#{HAUTEUR}) ; %% Le quadrillage
    \\draw [->,thick] (-#{LARGEUR+0.5},0) -- (#{LARGEUR+0.5},0) ; %% L\'axe optique
    \\draw [ultra thick] (0,-#{HAUTEUR}) -- (0,#{HAUTEUR})  ; %% Le corps du systeme 
"
  
  POSTAMBLE = "\n" + '  \end{tikzpicture}'

  ##################################################
  ## Pour choisir lentille/miroir convergent/divergent
  ##################################################
  
  def lentille_miroir
    if o.lentille
      return "
    % Dessin de la lentille et des points focaux
    \\draw [ultra thick] (-0.5,#{-HAUTEUR+o.fpsign*0.5}) -- (0,-#{HAUTEUR}) -- (0.5,#{-HAUTEUR+o.fpsign*0.5})
                         (-0.5,#{ HAUTEUR-o.fpsign*0.5}) -- (0, #{HAUTEUR}) -- (0.5,#{ HAUTEUR-o.fpsign*0.5}) ;
    \\filldraw [black] (#{ o.fp},0) circle (2pt) node [above #{right(o.fpsign)}] {$F'$};
    \\filldraw [black] (#{-o.fp},0) circle (2pt) node [above #{left(o.fpsign)}] {$F$} ;
    \\filldraw [black] (0,0) circle (2pt) node [above right] {$O$} ;
    "
    else
      return "
    \\draw [ultra thick] (#{-0.5*o.fpsign},#{-HAUTEUR-0.5}) -- (0,-#{HAUTEUR}) 
                         (#{-0.5*o.fpsign},#{ HAUTEUR+0.5}) -- (0, #{HAUTEUR}) ;
    \\filldraw [black] (#{-o.fp},0) circle (2pt) node [above #{right(o.fpsign)}] {$F$};
    \\filldraw [black] (#{-2*o.fp},0) circle (2pt) node [above #{left(o.fpsign)}] {$C$} ;
    \\filldraw [black] (0,0) circle (2pt) node [above right] {$S$} ;
    " + (0..(2*HAUTEUR-1)).to_a.map{|e| "\\draw [ultra thick] (0,#{-HAUTEUR+0.5+e}) -- (0.5,#{-HAUTEUR+0.5+e+0.5});"}.join("\n")
    end
  end

  ##################################################
  ## Routine pour dessiner le systeme avec l'objet
  ##################################################

  def dessin(option)
    tex_file = PREAMBLE
    if (option == 'corrige')
      tex_file = "
      \\begin{animateinline}[final,loop,controls,poster=last]{1}
          \\multiframe{8}{iCOUNT=00+01}{
      " + tex_file
    end
    ## D'abord lentille ou miroir, convergent ou divergent
    tex_file += lentille_miroir
    ## Puis la position de l'objet
    if (option == 'corrige' or option == 'objet') and o.p.abs < 1000
      post_txt = ''
      if option == 'corrige' and o.reverse
        tex_file += '\ifthenelse{\iCOUNT > 6}{' #+ "\n"
        post_txt = '}{}' + "\n"
      end
      tex_file += "
      \\draw [->,ultra thick] (#{o.p},0) node [#{below(o.AB)}] {$A$} -- (#{o.p},#{o.AB}) node [#{above(o.AB)}] {$B$} ;
      " + post_txt
    end
    ## Celle de l'image
    if (option == 'corrige' or option == 'image') and o.pp.abs < 1000
      post_txt = ''
      if option == 'corrige' and not(o.reverse)
        tex_file += '\ifthenelse{\iCOUNT > 6}{' #+ "\n"
        post_txt = '}{}' + "\n"
      end
      tex_file += "
      \\draw [->,ultra thick] (#{o.pp},0) node [#{below(o.ApBp)}] {$A'$} -- (#{o.pp},#{o.ApBp}) node [#{above(o.ApBp)}] {$B'$} ;
      " + post_txt
    end
    ## Enfin le trace des rayons caracteristiques en mode "corrige"
    if (option == 'corrige')
      decalage = 0
      decalage+= 1 if o.reverse
      nb = 0
      ## D'abord pour les lentilles
      if o.lentille
        tex_file += "% Le rayon qui arrive // a l'axe optique\n"
        tex_file += enrobage(rayon(o.p,o.AB,0,o.AB),nb+decalage)
        tex_file += "% ... arrive en passant par le foyer image\n"
        tex_file += enrobage(rayon(0,o.AB,o.fp,0,'image'),nb+(decalage+1)%2)
        tex_file += "% Le rayon qui passe par le centre optique\n"
        tex_file += enrobage(rayon(o.p,o.AB,0,0),nb+2+decalage)
        tex_file += "% ... n'est pas devie\n"
        tex_file += enrobage(rayon(o.p,o.AB,0,0,'image'),nb+2+(decalage+1)%2)
        tex_file += "% Le rayon qui passe par le foyer objet\n"
        tex_file += enrobage(rayon(o.p,o.AB,-o.fp,0),nb+4+decalage)
        tex_file += "% ... ressort // a l'axe optique\n"
        tex_file += enrobage(rayon(0,o.ApBp,o.pp,o.ApBp,'image'),nb+4+(decalage+1)%2)
      else
        tex_file += "% Le rayon qui passe par S\n"
        tex_file += rayon(o.p,o.AB,0,0)
        tex_file += "% ... est \"non devie\"\n"
        tex_file += rayon(o.p,-o.AB,0,0,'miroir')
        tex_file += "% Celui qui passe par C\n"
        tex_file += rayon(o.p,o.AB,-2*o.fp,0)
        tex_file += "% ... revient sur lui-meme\n"
        tex_file += rayon(o.p,o.AB,-2*o.fp,0,'miroir')
        tex_file += "% Celui qui arrive // a l'axe optique\n"
        tex_file += rayon(o.p,o.AB,0,o.AB)
        tex_file += "% ... repart en passant par le foyer \n"
        tex_file += rayon(o.pp,o.ApBp,-o.fp,0,'miroir')
        tex_file += "%Finalement, celui qui passe par le foyer revient // a l'axe optique\n"
        tex_file += rayon(o.p,o.AB,-o.fp,0)
        tex_file += rayon(o.pp,o.ApBp,0,o.ApBp,'miroir')
      end
    end
    tex_file += POSTAMBLE
    if option == 'corrige'
      tex_file += "}\n\\end{animateinline}"
    end
    File.open(o.basename + '_' + option + '.tex','w') do |f|
      f.puts tex_file
    end
  end

  ##################################################
  ## Enrobe un trace par un \ifthenelse
  ##################################################
  
  def enrobage(s,nb)
    return "\\ifthenelse{\\iCOUNT > #{nb}}{#{s}}{}\n"
  end


  ##################################################
  ## Trace d'un rayon selon deux points par lesquels il devrait passer
  ##
  ## Le type permet de savoir si on commence par un trait plein, puis des pointilles (objet) ou le contraire (image)
  ##################################################

  def rayon(x1,y1,x2,y2,type = 'objet')
    return '' if x1 == x2
    return '' if y1 == y2 && (x2.abs > 1000 || x1.abs > 1000)
    a = (y2-y1)/(x2-x1)
    return '' if a > 100
#    puts [x1,x2,y1,y2,a].join("\t")
    b = y1 - a*x1
    hneg   =  -a*LARGEUR+b
    hpos   =   a*LARGEUR+b
    hneg_sign = hneg.abs/hneg
    hpos_sign = hpos.abs/hpos
    gauche = ((hneg).abs > HAUTEUR && a!=0) ?  "(#{arrondi((hneg_sign*HAUTEUR - b)/a)},#{arrondi(hneg_sign*HAUTEUR)})"  : "(-#{LARGEUR},#{arrondi(-a*LARGEUR+b)})"
    milieu = ''
    droite = ((hpos).abs > HAUTEUR && a!=0) ?  "(#{arrondi((hpos_sign*HAUTEUR - b)/a)},#{arrondi(hpos_sign*HAUTEUR)})"  : "(#{LARGEUR},#{arrondi(a*LARGEUR+b)})"
    return "
    \\draw [thick #{type == 'objet' || type == 'miroir' ? (type == 'miroir' ? ',<<-' : ',>>-') : ', dashed'}] #{gauche} -- (0,#{arrondi(b)});
    \\draw [thick #{type == 'objet' || type == 'miroir' ? ', dashed' : ',->>'}] (0,#{arrondi(b)}) -- #{droite};
    "
  end

  ##################################################
  ## Arrondi a 3 chiffres apres la virgule
  ##################################################

  def arrondi(x)
    return (x*1000).round/1000.0
  end

  ##################################################
  ## Pour savoir si on met les noms au-dessus ou en dessous
  ##################################################

  def below(x)
    return 'below' if x>0
    return 'above'
  end

  def above(x)
    return 'below' if x<0
    return 'above'
  end

  def right(x)
    return 'right' if x>0
    return 'left'
  end

  def left(x)
    return 'left' if x>0
    return 'right'
  end


  ##################################################
  ## Running routine
  ##################################################

  def run
    dessin('objet') if not(o.reverse)
    dessin('image') if o.reverse
    dessin('corrige')
  end
end

##################################################
## The program in itself
##################################################

prog = FaisSchemaLentilleOuMiroir.new
prog.read_options
prog.run
