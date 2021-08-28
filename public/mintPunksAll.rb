###
#  to run use:
#     ruby ./mint.rb


require 'cryptopunks'

punks = Punks::Image::Composite.read( './i/punks.png' )


$i = 0
$num = 10000

puts "   #{10000} alien metadata record(s)"

while $i < $num  do
  filename = "./i/brownie/%s%04d.png" % ["punk-", $i]
  filename4x = "./i/brownie/%s%04dx4.png" % ["punk-", $i]
  filename8x = "./i/brownie/%s%04dx8.png" % ["punk-", $i]
  punks[$i].save( filename )
  punks[$i].zoom(4).save(filename4x)
  punks[$i].zoom(8).save( filename8x)
  $i +=1
end
