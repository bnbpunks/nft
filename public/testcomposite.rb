
require 'cryptopunks'

PARTS = {
  face:  { required: true,
           attributes: [['', 'u'],
                        ['', 'u'],
                        ['', 'u'],
                        ['', 'u'],
                        ['', 'u'],
                        ['', 'u'],
                        ['', 'u'],
                        ['', 'u']] },
  nose:  { required: true,
           attributes: [['',          'u'],
                        ['Nose Ring', 'u']] },
  eyes:  { required: true,
           attributes: [['Clear Black',          'u'],
                        ['Clear Blue',          'u'],
                        ['Red Black',          'u'],
                        ['Red Green',          'u'],
                        ['Red Green',          'u'],
                        ['Red Blue', 'u']] },
  mouth:  { required: true,
           attributes: [['',          'u'],
                        ['',          'u'],
                        ['',          'u'],
                        ['Nose Ring', 'u']] },
  hair:  { required: false,
           attributes: [['Up Hair',        'm'],
                        ['Up Hair',        'm'],
                        ['Up Hair',        'm'],
                        ['Up Hair',        'm'],
                        ['Up Hair',        'm'],
                        ['Up Hair',        'm'],
                        ['Up Hair',        'm'],
                        ['Up Hair',        'm'],
                        ['Up Hair',        'm'],
                        ['Up Hair',        'm'],
                        ['Up Hair',        'm'],
                        ['Up Hair',        'm'],
                        ['Green Hair',    'f']] },
  glasses:  { required: true,
           attributes: [['',          'u'],
                        ['',          'u'],
                        ['',          'u'],
                        ['',          'u'],
                        ['',          'u'],
                        ['',          'u'],
                        ['',          'u'],
                        ['',          'u'],
                        ['Nose Ring', 'u']] }
 }



def generate_punk( codes )
  punk = Pixelart::Image.new( 24, 24 )

  PARTS.each_with_index do |(key,part),i|
    code  = codes[i]
    if code != 0
      attribute = part[:attributes][ code-1 ]
      puts "#{key}#{code} - #{attribute[0]} (#{attribute[1]})"  if attribute[0].size > 0

      path = "./i/parts/#{key}/#{key}#{code}.png"
      part = Pixelart::Image.read( path )
      punk.compose!( part )
    end
  end

  punk
end


composite = Punks::Image::Composite.new( 100, 100 )

$i = 0
$num = 10000

puts "   #{100} alien metadata record(s)"

while $i < $num  do
   filename = "%s/%s%04d.png" % ["tmp", "punk-", $i]
   puts("Inside the loop i = #$i" )
   $i +=1
   codes = [rand(1..8), rand(1..2), rand(1..6), rand(1..4), rand(1..13), rand(1..9)]
   punk = generate_punk( codes )
   punk.save( filename )
   composite << punk
end

composite.save( "i/browniepunks.png" )
