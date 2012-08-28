

# terribly ugly, but gets the job done
# TODO: Couldn't get a singleton to work here so were gonna use a shitty global
#
module Helpers
  module Cache
    require "moneta/memory"

    def get_helper_cache
      node.run_state[:helper_cache] = Moneta::Memory.new unless node.run_state.has_key?(:helper_cache)
      node.run_state[:helper_cache]
    end
  end
end

class Chef
  class Recipe
    include Helpers::Cache
  end
end
