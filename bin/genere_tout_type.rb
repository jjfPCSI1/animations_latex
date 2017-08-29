#!/usr/bin/ruby -w
# Petit script a appeler depuis la racine du projet github et non depuis le repertoire bin/

Dir.chdir('animations_lentilles') do 
  ['l'].each do |type|
    ['-',''].each do |sign|
      ['o','i'].each do |obj|
        17.times do |i|
          next if i == 8 ## On saute le cas du centre optique
          #next unless i == 0 or i == 16
          cmd = "../bin/fais_animation_lentille.rb -#{type} #{sign}2 -#{obj} #{i-8},2"
          puts cmd
          system cmd
        end
      end
    end
  end
end
