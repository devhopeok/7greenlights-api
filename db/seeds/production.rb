Rails.logger.info { 'Creating Arenas...' }
#create arenas
arenas = YAML.load(File.read('db/seeds/data/arenas.yml'))
arenas.each do |arena|
  arena['end_date'] = DateTime.parse(arena['end_date'])
end
Arena.create(arenas)
Rails.logger.info { 'Success' }
