module Nanoc::Filters
  class EditOnGitLabLink < Nanoc::Filter
    identifier :edit_on_gitlab_link

    def run(content, params = {})
      # Returns the source content's path.
      content_filename = @item[:content_filename]
      # Make an array out of the path
      content_filename_array = content_filename.split('/')
      # Remove "/content/"
      content_filename_array.shift
      # Get the product name.
      product = content_filename_array.shift
      # This should be the path from the doc/ directory for a given file.
      content_filename = content_filename_array.join("/")

      # Replace `EDIT_ON_GITLAB_LINK` with the actual URL.
      content.gsub(/href="(EDIT_ON_GITLAB_LINK)"/) do |result|
        result.gsub!(/EDIT_ON_GITLAB_LINK/, "https://gitlab.com/gitlab-org/gitlab-#{product}/blob/master/doc/#{content_filename}")
        result
      end
    end
  end
end
