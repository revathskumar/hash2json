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
        # hash = hash.to_s.stringify_keys
        # if old
          # hash = Hash[hash.to_s.gsub('{', '').gsub('}', '').split(",").collect{|x|
          #     x.gsub(/:| |\'/,'').gsub('nil', 'null').split("=>")
          # }]
          # p hash
          # hash = hash.stringify_keys
          # p hash
        # end
        json = if hash && old
          JSON.parse(hash.to_s.gsub('=>', ':')).to_json
        else
          hash
        end
        hash.gsub!('\\','')
        res.write render('templates/home.haml', hash: input , json: json)
      end
      res.write render('templates/home.haml', hash: '' , json: '')
    end
  end
end


# class Hash
#   def stringify_keys
#     t = self.dup
#     self.clear
#     t.each_pair{|k, v| self[k.to_s] = v}
#     self
#   end
# end
