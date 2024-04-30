# Directories
# A directory under the posts directory should have should have 
# /network/11-11-11-index.html. You should add the subdirectory layout. 
# This file lists out all files under the directory.

# Files
# A varaible date, month, year that I'll be used for the date [%m-%d%-Y] format 
# and for the url since it's in /year/month/date/filename.html.

require 'find'
require 'date'

module Jekyll
  module ListFiles
    def list(folder)
      renamed_entries = {}
      Dir.foreach(folder) do |filename|
        next if filename.start_with?('.')
        path = File.join(folder, filename)
        if File.directory?(path)
          renamed_entries["#{filename}"] = { 'type' => 'directory', 'class' => 'directory', 'path' => nil, 'date' => nil }
        elsif File.file?(path) && File.extname(path) == '.md'
          ignore_file = "11-11-11-index"
          base_name = File.basename(path, '.*')
          next if base_name == ignore_file # ignore the index.md
          date_string = base_name.match(/^\d{4}-\d{2}-\d{2}-/)[0][0..-2] 
          date = Date.parse(date_string) # YEAR-MONTH-DATE
          new_base_name = base_name.sub(/^\d{4}-\d{2}-\d{2}-/, '')
          # FIXME: This should get the title: attribute from the file.
          new_file_name = "#{new_base_name}.txt"
          # /2023/11/11/update-cisco-vlan.html [11-11-2023] update-vlan.txt 
          year  = '%02i' % date.year
          month = '%02i' % date.month
          day   = '%02i' % date.day

          folder_parts = folder.split('/')
          if folder_parts.length == 2 && folder_parts[0] == '_posts'
            category = folder_parts[1]
            file_path = "/#{category}/#{year}/#{month}/#{day}/#{new_base_name}.html"
          else
            file_path = "/#{year}/#{month}/#{day}/#{new_base_name}.html"
          end 

          # FIXME: There should be a base path. Where the back button goes to either 
          # root / or /catgetory/.
          renamed_entries[new_file_name] = { 'type' => 'file', 'class' => 'file', 'path' => file_path, 'date' => nil }
        else
          renamed_entries[filename] = { 'type' => 'other', 'class' => 'other', 'path' => nil, 'date' => nil }
        end
      end
      renamed_entries
    end
  end
end

Liquid::Template.register_filter(Jekyll::ListFiles)

