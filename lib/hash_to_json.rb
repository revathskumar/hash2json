require 'cuba'
require 'cuba/render'
require 'json'

Cuba.plugin Cuba::Render

Cuba.define do

  on get do
    on root do
      hash = ''
      on param('q') do | hash |
        json = if hash && hash[ /=>/ ]
          JSON.parse(hash.gsub('nil', '').gsub('=>', ' : ')).to_json
        else
          hash
        end
        res.write render('templates/home.haml', hash: hash , json: json)
      end
      res.write render('templates/home.haml', hash: '' , json: '')
    end
  end
end
