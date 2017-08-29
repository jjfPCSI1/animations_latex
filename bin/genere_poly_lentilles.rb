#!/usr/bin/ruby -w

# Script a appeler depuis la racine du projet github et non depuis le repertoire bin/

LCO = Dir.glob('anim*len*/LCO*corrige.tex')
LCI = Dir.glob('anim*len*/LCI*corrige.tex')
LDO = Dir.glob('anim*len*/LDO*corrige.tex')
LDI = Dir.glob('anim*len*/LDI*corrige.tex')
#MCO = Dir.glob('len*/MCO*corrige.tex')
#MCI = Dir.glob('len*/MCI*corrige.tex')
#MDO = Dir.glob('len*/MDO*corrige.tex')
#MDI = Dir.glob('len*/MDI*corrige.tex')

PREAMBLE = '\documentclass{article}

\input{sty_files/packages.sty}
\input{sty_files/macros.sty}

\usepackage{vmargin}
\setmarginsrb{10mm}{10mm}{10mm}{5mm}{12pt}{11mm}{0pt}{11mm}

\newcommand{\titre}[1]{\hfill{\Large\textbf{#1}}\hfill \medskip}

\begin{document}
'

POSTAMBLE = '\end{document}'

File.open('poly_lentilles.tex','w') do |f|

  f.puts PREAMBLE
  8.times do |i|
    exos_objet = []
    exos_image = []
#    [LCO,LCI,LDO,LDI,MCO,MCI,MDO,MDI].each do |array|
    [LCO,LCI,LDO,LDI].each do |array|
      m = array.select{|e| e =~ /-/}.shuffle!
      p = (array - m).shuffle!
      exos = array[0] =~ /I/ ? exos_image : exos_objet
      exos.push(m.shift).push(m.shift).push(p.shift).push(p.shift)
    end
    exos_objet.shuffle!
    exos_image.shuffle!
    tabular_objet = '\begin{tabular}{|c|c|}' + "\n" + '\hline' + "\n" 
    exos_objet.map{|e| '\input{' + e + '}'}.each_slice(2) {|s| tabular_objet += s.join("&") + '\\\\ \hline' + "\n"}
    tabular_objet+= '\end{tabular}'
    tabular_image = '\begin{tabular}{|c|c|}' + "\n" + '\hline' + "\n" 
    exos_image.map{|e| '\input{' + e + '}'}.each_slice(2) {|s| tabular_image += s.join("&") + '\\\\ \hline' + "\n"}
    tabular_image+= '\end{tabular}'

    f.puts '\setcounter{page}{1}'
    f.puts "\\titre{Images \\`a tracer pour quelques objets r\\'eels ou virtuels}"
    f.puts tabular_objet.gsub(/corrige/,'objet')
    f.puts "\n\n" + '\newpage' + "\n\n\n"
    f.puts "\\titre{Images \\`a tracer pour quelques objets r\\'eels ou virtuels: Correction}"
    f.puts tabular_objet
    f.puts "\n\n" + '\newpage' + "\n\n"
    f.puts "\\titre{Objets \\`a trouver pour quelques images r\\'eelles ou virtuelles}"
    f.puts tabular_image.gsub(/corrige/,'image')
    f.puts "\n\n" + '\newpage' + "\n\n\n"
    f.puts "\\titre{Objets \\`a trouver pour quelques images r\\'eelles ou virtuelles: Correction}"
    f.puts tabular_image
    f.puts "\n\n"
    f.puts '\newpage'
  end
  
  f.puts POSTAMBLE
end


## Le poly prof

File.open('poly_prof_lentilles.tex','w') do |f|

  f.puts PREAMBLE

    exos_objet = []
    exos_image = []
#    [LCO,LCI,LDO,LDI,MCO,MCI,MDO,MDI].each do |array|
    [LCO,LCI,LDO,LDI].each do |array|
      m = array.select{|e| e =~ /-/}.reverse
      p = array - m
      exos = (array[0] =~ /I/ ? exos_image : exos_objet)
      exos.push(m.flatten).push(p.flatten)
    end
    exos_objet.flatten!
    exos_image.flatten!
    tabular_objet = ''
    exos_objet.map{|e| '\input{' + e.sub(/corrige/,'objet') + '} & \input{' + e + '} \\\\ \hline' + "\n"}.each_slice(4) do |s|
      tabular_objet+= '\begin{tabular}{|c|c|}' + "\n" + '\hline' + "\n" 
      tabular_objet+= s.join('')
      tabular_objet+= '\end{tabular}' + "\n"
      tabular_objet+= '\newpage' + "\n\n"
    end
    tabular_image = ''
    exos_image.map{|e| '\input{' + e.sub(/corrige/,'image') + '} & \input{' + e + '} \\\\ \hline' + "\n"}.each_slice(4) do |s|
      tabular_image+= '\begin{tabular}{|c|c|}' + "\n" + '\hline' + "\n" 
      tabular_image+= s.join('')
      tabular_image+= '\end{tabular}' + "\n"
      tabular_image+= '\newpage' + "\n\n"
    end

    f.puts "\\titre{Images \\`a tracer pour quelques objets r\\'eels ou virtuels}"
    f.puts tabular_objet
#    f.puts "\n\n" + '\newpage' + "\n\n\n"
    f.puts "\\titre{Objets \\`a trouver pour quelques images r\\'eelles ou virtuelles}"
    f.puts tabular_image
    f.puts "\n\n"
#    f.puts '\newpage'

  f.puts POSTAMBLE

end
