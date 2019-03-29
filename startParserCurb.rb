require 'curb'
require 'nokogiri'
require 'csv'


def parsing(url,wr)

  html=Curl.get(url)
  doc=Nokogiri::HTML(html.body_str)

  names=[]
  answer=[]
  threads=[]

  doc.xpath('//a[@class="product_img_link product-list-category-img"]/@href').each do |row|
    threads<<Thread.new do
      begin
        url=row
        html=Curl.get(url)
        docOne=Nokogiri::HTML(html.body_str)

        urlImg=docOne.xpath('//img[@id="bigpic"]/@src').text.strip()
        name=docOne.xpath('//div[@class="nombre_fabricante_bloque col-md-9 desktop"]').text.strip()

        i=0
        docOne.xpath('//span[@class="radio_label"]').each do |row1|
          names[i]=name+" - "+row1
          i+=1
        end


        i=0
        docOne.xpath('//span[@class="price_comb"]').each do |row1|
          puts"Записываем продукт \""+name+"-"+names[i]+"\" в "+@file+".scv файл"
          answer[0]=names[i]
          answer[1]=row1.text.strip()
          answer[2]=urlImg
          wr<<answer
          i+=1
        end
      rescue
        puts("!!!!!!!!ОШИБКА 404!!!!!!!!")
      end
    end
  end
  threads.each(&:join)
end



puts "enter url:"
url=gets.chomp().strip

puts "enter file:"
@file=gets.chomp().strip

threads=[]

if(url=="https://www.petsonic.com/snacks-huesos-para-perros/")
  CSV.open(@file+".csv","wb") do |wr|

    for i in 1..10
      puts "запуск парсинга страницы №"+i.to_s
      threads<<Thread.new(i) do |i|
        parsing(url+"?p=#{i}",wr)
      end
    end

    threads.each(&:join)
  end

  puts "         ##########################\n
              PARSING FINISHED"

else
  puts"Ошибка!\nЯ могу парсит только этот url: https://www.petsonic.com/snacks-huesos-para-perros/"
end
