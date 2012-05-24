 # Author::    Maurizio Casimirri (mailto:maurizio.cas@gmail.com)
 # Copyright:: Copyright (c) 2012 Maurizio Casimirri
 # 
 # Permission is hereby granted, free of charge, to any person obtaining
 # a copy of this software and associated documentation files (the
 # "Software"), to deal in the Software without restriction, including
 # without limitation the rights to use, copy, modify, merge, publish,
 # distribute, sublicense, and/or sell copies of the Software, and to
 # permit persons to whom the Software is furnished to do so, subject to
 # the following conditions:
 # 
 # The above copyright notice and this permission notice shall be
 # included in all copies or substantial portions of the Software.
 # 
 # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 # EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 # MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 # NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 # LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 # OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 # WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module PaperclipSchema
  extend ActiveSupport::Concern

  module ClassMethods

    def has_attached(name, options = {})

      options[:url]  ||= "/attachments/:class/:id/:attachment/:style/:basename.:extension"
      options[:path] ||= ":rails_root/public/attachments/:class/:id/:attachment/:style/:basename.:extension"

      if Rails.env.production?
        options[:storage] = 's3'
        options[:s3_credentials] = Rails.root.join("config", "s3.yml")
      else
        options[:storage] = 'filesystem'
      end
      has_attached_file(name, options)
      
      field :"#{name}_file_name"
      field :"#{name}_content_type"
      field :"#{name}_file_size", :as => :integer
      field :"#{name}_updated_at", :as => :datetime

      validate do |record|
        if record.send(name) && !record.send(name).errors.empty?
          file_name = record.send(:"#{name}_file_name")
          record.errors.add name, "Paperclip returned errors for file '#{file_name}' - check ImageMagick installation or image source file."
          false
        end
      end

    end

  end # ~ ClassMethods

end

ActiveRecord::Base.send :include, PaperclipSchema
