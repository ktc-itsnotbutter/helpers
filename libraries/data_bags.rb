        
module Helpers
    module DataBag

    # data_bag_fqdn
    #  This helper converts a fqdn from . notation to -'s 
    # used to encode hostnames into databag names. since databags restrict using periods
    def data_bag_fqdn(fqdn=node.fqdn)
      escape_bagname(fqdn)
    end

    # escape  . -> - and / -> _  
    # so 1.1/3 -> 1-1_3 
    def escape_bagname(name)
      n = name.gsub(/\./,'-')
      n.gsub(/\//,'_')
    end

  end
end

# Mix this helper in recipe 
class Chef
  class Recipe
    include Helpers::DataBag
  end
end

