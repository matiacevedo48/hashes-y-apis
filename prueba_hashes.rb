require 'uri'
require 'net/http'
require 'openssl'
require 'json'

def request(url_request)
    url = URI(url_request)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["app_id"] = '763a76be-4e04-4b15-bc59-3a241516ec46'
    request["app_key"] = 'irK0NJr0swnz5bt07Ptr3ds0jxv03xarhf3hKSI1'
    response = http.request(request)
    return JSON.parse(response.body)
end

def build_web_page(arreglo)
    new_array = arreglo["photos"]
    values = (new_array.map {|photos| [photos["img_src"]]})
    output = "<html>\n<head>\n</head>\n<body>\n<ul>"
    values.each do |img|
        img.each do |inner|
            str = img.to_s
            str = str.slice(1..str.length-1)
            output += "\n\t<li><img src=#{str} /></li>"  
        end
    end
    output += "\n</ul>\n<body>\n</html>"
    File.write('index.html', output)   
end

def photos_count(arreglo)
    arreglo_final = []
    new_array = arreglo["photos"]
    values = (new_array.map {|photos| [photos["camera"]]})
    values.each do |img|
        img.each do |inner|
            inner.each do |k,v|
                if k == "name"
                    arreglo_final << v  
                end
            end
        end
    end
    camaras = arreglo_final.group_by {|x| x}
    camaras.each do |k,v|
        camaras[k] = v.count
    end
    return camaras
end

link = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=irK0NJr0swnz5bt07Ptr3ds0jxv03xarhf3hKSI1"
body = request(link)
build_web_page(body)
camera = photos_count(body)
puts body #Para probar resultado del metodo request
puts camera #Para probar resultado del metodo photos_count