xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Noistter - "+@termino
    xml.link "http://noistter.com/"
    xml.description "RSS de búsqueda de tipo"+@tipo+" y con término "+@termino
    for tweet in @tpuntuacion
      xml.item do
        xml.title tweet.instance_variable_get(:@username)
        xml.link tweet.instance_variable_get(:@link)
        xml.description tweet.instance_variable_get(:@text)
      end
    end
  end
end