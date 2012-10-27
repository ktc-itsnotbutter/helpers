module Helpers
  module Data
    def merge_and_flatten(attribs, data)
      parameters = []
      parametersh = {}
      attribs.each {|k, v| parametersh[k] = v}
      parametersh.merge!(data)
      parametersh.each {|k, v| parameters.push("#{k} #{v}")}
      parameters.sort! 
    end
  end
end

class Chef
  class Recipe
    include Helpers::Data
  end
end

