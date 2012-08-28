#  Chef related helpers should go here
#

#
# Reduce the verbosity of Chef 10 logging messages
#
class Chef
  class Log
    # Processing... messages should go in the debug level
    def self.info(msg=nil, &block)
      if msg =~ /^Processing/
        debug(msg, &block)
      else
        super
      end
    end
  end
end


#
# work around for HTTP Gzip bug
# refrenced here: http://tickets.opscode.com/browse/CHEF-3218
# should remove when that bug is fixed
# 
class Chef
  class Provider
    class HttpRequest < Chef::Provider
      def load_current_resource
        @rest = Chef::REST.new(@new_resource.url, nil, nil, :disable_gzip => true)
      end
    end
  end
end

