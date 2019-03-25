require 'open-uri'
require 'nokogiri'
require 'csv'

url='https://www.petsonic.com/snacks-huesos-para-perros/'
html=open(url)
doc=Nokogiri::HTML(html)

CSV.open("test2.csv","wb") do |wr|

  answer=Array[3]
  name=[]
  price=[]
  img=[]

  doc.xpath('//a[@class="product_img_link product-list-category-img"]/@href').each do |row|

  print"----------------\n"+row
    url=row
    html=open(url)
    docOne=Nokogiri::HTML(html)
    urlImg=docOne.xpath('//img[@id="bigpic"]/@src').text.strip
    name=docOne.xpath('//div[@class="nombre_fabricante_bloque col-md-9 desktop"]').text.strip

    i=0
    docOne.xpath('//span[@class="radio_label"]').each do |row1|
      print "\n"+name+" - "+row1
    end

    i=0
    docOne.xpath('//span[@class="price_comb"]').each do |row1|
      print "\n"+row1.text.strip
    end
  print "\n"+urlImg+"\n"

  wr <<[name,price,img]


end



end
