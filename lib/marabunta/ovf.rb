module Marabunta
  require 'nokogiri'

  class Ovf
    NAMESPACE = {'ovf' => 'http://schemas.dmtf.org/ovf/envelope/1'}

    attr_reader :xml

    def initialize(ovf_file)
      @xml = Nokogiri::XML(File.read(ovf_file)) do |config|
        config.strict.noent
        config.strict
      end.root
    end

    def disks
      # TODO:
      #   The href path could be extracted by once but we ensure there is a
      # matching relationship.
      #   Remove this matching if it's not required from OVF.
      @xml.xpath('//ovf:Disk', NAMESPACE).map do |disk| 
        ref = disk.attr('fileRef')
        file = xml.xpath("//ovf:File[@ovf:id = '#{ref}']", NAMESPACE).first and file.attr('href')
      end
    end
  end
end
