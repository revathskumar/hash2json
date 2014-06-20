require 'cuba'
require 'cuba/render'
require 'json'

Cuba.plugin Cuba::Render

Cuba.define do

  on get do
    on root do
      input = hash = ''
      on param('q') do | hash |
        input = hash
        old = hash[ /=>/ ]
        isjson = hash[/:(|\ ){/]
        unless isjson
          if old
            hash = hash.gsub('nil', 'null').gsub(/:(\s)/, "\"(\s)\"" ).gsub("=>",':')
          else
            hash = hash.to_s.gsub('{', '').gsub('}', '')
            hash = Hash[hash.split(",").collect{|x|
                x.gsub('nil', 'null').split(': :')
            }]
            hash = hash.stringify_keys
          end
        end
        if hash
          json = JSON.parse(hash.to_s.gsub('=>', ':').gsub('\\','')).to_json
        end
        res.write render('templates/home.haml', hash: input , json: json)
      end
      res.write render('templates/home.haml', hash: '' , json: '{}')
    end
  end
end


class Hash
  def stringify_keys
    t = self.dup
    self.clear
    t.each_pair{|k, v|
      self[k.to_s.gsub(/^\"|\"$/, '')] = v.gsub(/^\"|\"$/, '')
    }
    self
  end
end
