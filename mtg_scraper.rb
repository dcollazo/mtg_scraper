require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'curb'
require 'restclient'

cf_cards_hash = {
	"Abrupt Decay" => "Return to Ravnica", "Ajani, Caller of the Pride" => "Magic 2013", 
	"Angel of Serenity" => "Return to Ravnica", "Armada Wurm" => "Return to Ravnica", 
	"Avacyn, Angel of Hope" => "Avacyn Restored", "Blood Crypt" => "Return to Ravnica", 
	"Bonfire of the Damned" => "Avacyn Restored", "Cavern of Souls" => "Avacyn Restored", 
	"Detention Sphere" => "Return to Ravnica", "Entreat the Angels" => "Avacyn Restored", 
	"Epic Experiment" => "Return to Ravnica", "Falkenrath Aristocrat" => "Dark Ascension", 
	"Garruk Relentless" => "Innistrad", "Geist of Saint Traft" => "Innistrad", 
	"Geralf's Messenger" => "Dark Ascension", "Gravecrawler" => "Dark Ascension", 
	"Griselbrand" => "Avacyn Restored", "Hallowed Fountain" => "Return to Ravnica", 
	"Hinterland Harbor" => "Innistrad", "Huntmaster of the Fells" => "Dark Ascension", 
	"Isolated Chapel" => "Innistrad", "Jace, Architect of Thought" => "Return to Ravnica",  
	"Jace, Memory Adept" => "Magic 2013", "Liliana of the Dark Realms" => "Magic 2013", 
	"Liliana of the Veil" => "Innistrad", "Lotleth Troll" => "Return to Ravnica", 
	"Niv-Mizzet, Dracogenius" => "Return to Ravnica", "Overgrown Tomb" => "Return to Ravnica", 
	"Rakdos's Return" => "Return to Ravnica", "Rakdos, Lord of Riots" => "Return to Ravnica", 
	"Restoration Angel" => "Avacyn Restored", "Snapcaster Mage" => "Innistrad", 
	"Sphinx's Revelation" => "Return to Ravnica", "Sorin, Lord of Innistrad" => "Dark Ascension", 
	"Steam Vents" => "Return to Ravnica", "Sublime Archangel" => "Magic 2013", "Sulfur Falls" => "Innistrad", 
	"Tamiyo, the Moon Sage" => "Avacyn Restored", "Temple Garden" => "Return to Ravnica", 
	"Temporal Mastery" => "Avacyn Restored", "Thragtusk" => "Magic 2013", 
	"Thundermaw Hellkite" => "Magic 2013", "Vraska the Unseen" => "Return to Ravnica", 
	"Woodland Cemetery" => "Innistrad", "Trostani, Selesnya's Voice" => "Return to Ravnica"
} 

prices_array = []
prices_hash = {}

cf_cards_hash.each do |card, expansion|
	sleep(1)
	cf_prices = []
	card = card.gsub(' ', '+')
	expansion = expansion.gsub(' ', '+')

	open("http://store.channelfireball.com/products/search?q=#{card}+#{expansion}&section=store").each_line do |s|
		cf_price = s.match(/g>\$...../) if s.include?('ng>$')
		cf_prices << cf_price.to_s.gsub('g', '').gsub('>', '').gsub('$', '').to_f
		cf_prices.sort!.select! { |price| price.to_f > 5.00 && price.to_f < 60.00}
		cf_prices.length > 3 && cf_prices[0] < 8 ? @cf_price = cf_prices.slice(1..-1).min : @cf_price = cf_prices.min
		prices_hash["#{card.gsub('+', ' ')}"] = @cf_price
	end


	cf_ranked_array = prices_hash.sort_by {|key, value| value }.reverse
	cf_ordered_hash = {}
	cf_ranked_array.each do |card|
		cf_ordered_hash[card[0].downcase.gsub(' ', '_').gsub(',', '')] = card[1]
	end

	p card

	File.open("average_prices.rb", "w") { |f| f.write(cf_ordered_hash)}
	
end