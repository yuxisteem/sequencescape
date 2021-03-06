class Parsers::QuantParser
  class InvalidFile < StandardError; end

  HEADER_IDENTIFIER = 'Headers'.freeze
  LOCATION_HEADER = 'Well Location'.freeze
  COLUMN_MAPS = {
    'concentration' => :set_concentration,
    'molarity'      => :set_molarity,
    'volume'        => :set_current_volume,
    'rin'           => :set_rin
  }.freeze

  def initialize(content)
    @content = content
  end

  def self.headers_index(content)
    content.find_index { |l| l[0] == HEADER_IDENTIFIER }
  end

  def self.parses?(content)
    (content[0][0] == 'Assay Plate Barcode') && headers_index(content)
  end

  def each_well_and_parameters
    data_section.each do |row|
      # If location is nil or blank, ignore the row
      next if row[location_index].nil? || row[location_index].strip.blank?
      yield(row[location_index], qc_values_for_row(row))
    end
  end

  private

    def location_index
      @location_index ||= headers_section.find_index { |cell| cell == LOCATION_HEADER }
    end

    def headers_section
      @content[headers_index + 1]
    end

    def data_section
      @content.slice(headers_index + 2, @content.length)
    end

    def column_maps
      COLUMN_MAPS
    end

    def method_set_list
      @method_set_list ||= headers_section.map do |description|
        next if description.blank?
        column_maps[description.strip.downcase]
      end
    end

    def qc_values_for_row(row)
      Hash[method_set_list.zip(row).reject { |header, _value| header.nil? }]
    end

    def headers_index
      @headers_index ||= self.class.headers_index(@content)
    end
end
