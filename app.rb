#!/usr/bin/ruby
require 'yaml'
require 'FileUtils'
require 'ovh/rest'
require 'launchy'
require 'highline/import'

config = YAML.load_file('config.yml')

BACKUP_DIR      = 'backups'
API_KEY         = config['API_KEY']
API_SECRET      = config['API_SECRET']
CONSUMER_KEY    = config['CONSUMER_KEY']

if !CONSUMER_KEY

    access = {
      "accessRules" => [
        { "method" => "GET", "path" => "/domain/*" }
      ]
    }

    auth = OVH::REST.generate_consumer_key(API_KEY, access, 'https://eu.api.ovh.com/1.0')
    puts JSON.pretty_generate(auth)

    CONSUMER_KEY = auth['consumerKey'];
    puts CONSUMER_KEY

    Launchy.open(auth['validationUrl'])

    answer = ask("Done ? [Enter]")

    FileUtils.mkdir_p "#{BACKUP_DIR}"

    config['CONSUMER_KEY'] = CONSUMER_KEY
    File.open('config.yml','w') do |h|
       h.write config.to_yaml
    end

end

ovh = OVH::REST.new(API_KEY, API_SECRET, CONSUMER_KEY, 'https://eu.api.ovh.com/1.0')

domains = ovh.get("/domain/zone")
puts JSON.pretty_generate(domains)

domains.each do |domain|
    puts domain
    FileUtils.mkdir_p "#{BACKUP_DIR}/#{domain}"
    begin  
        export = ovh.get("/domain/zone/#{domain}/export")
        puts eval(export)

        recordFile = File.new("#{BACKUP_DIR}/#{domain}/#{domain}_dns-export.txt", "w+")
        if recordFile
            recordFile.syswrite(eval(export))
        else
           puts "Unable to open file!"
        end
        recordFile.close

    rescue Exception => e  
      puts e.message  
      puts e.backtrace.inspect  
    end  
end
