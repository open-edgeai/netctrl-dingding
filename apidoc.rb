Dir['doc/*'].each do |child|
  puts "processing #{child}"
  fname=File.basename(child, '.apib')
  `aglio --theme-variables slate -i doc/#{fname}.apib -o public/api-doc/#{fname}.html`
  `apib2swagger -i doc/#{fname}.apib -o public/livedoc/#{fname}.json `

end
