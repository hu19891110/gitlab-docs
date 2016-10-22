module Nanoc::Helpers
  module ChildParentBetter
    # Returns an array of ancestor pages for the given page.
    def ancestor_path_array(item)
      if @config[:debug]
        puts item
      end
      parent_array = Array.new
      current_item = item
      # Until the current item has no parent, keep running.
      until (get_nearest_parent(current_item.identifier.to_s).nil?) do
        # Set the current item to the last item in the array
        # unless this is the first item.
        current_item = parent_array.last unless parent_array.empty?
        # Get the nearest parent of the current item.
        parent = get_nearest_parent(current_item.identifier.to_s)
        # Push the parent of the current item into the array.
        parent_array.push(parent) if parent
      end

      parent_array
    end

    # A recursive function which returns the nearest parent item for the
    # given path.
    def get_nearest_parent(item_identifier)
      if @config[:debug]
        puts item_identifier
      end
      
      # If the nearest parent is non-exist or is the README for the product,
      # return and end the recursion.
      if (item_identifier.nil? || (item_identifier.to_s.end_with?('README.md', 'index.md') && item_identifier.to_s.split('/').length == 4))
        return
      elsif item_identifier.to_s.end_with?('README.md', 'index.md')
        parent_dir = item_identifier.sub(/[^\/]+$/, '').chop
        return get_nearest_parent(parent_dir)
      else
        parent_dir = item_identifier.sub(/[^\/]+$/, '').chop
        parent = @items[parent_dir + '/README.*']
        alt_parent = @items[parent_dir + '/index.*']
        if (parent.nil? && alt_parent.nil?)
          get_nearest_parent(parent_dir)
        elsif alt_parent.nil?
          return parent
        else
          return alt_parent
        end
      end
    end
  end
end
