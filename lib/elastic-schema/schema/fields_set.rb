module ElasticSchema::Schema

  class FieldsSet

    FieldAlreadyDefined = Class.new(StandardError)

    attr_reader :fields, :parent

    def initialize(parent)
      @fields = []
      @parent = parent
    end

    def << field
      field.parent = self
      fail FieldAlreadyDefined.new("'#{field.full_name}' already exists.") if find(field.name)
      fields << field
    end

    def routing(options)
      @routing_options = options
    end

    def find(field_name)
      fields.bsearch { |field| field.name == field_name }
    end

    def full_name
      parent.full_name
    end

    def to_hash
      return {} if fields.empty?
      hash = { 'properties' => fields.inject({}) { |_fields, field| _fields.update(field.to_hash) } }
      hash.update('_routing' => @routing_options) if @routing_options.present?

      hash
    end
  end

end
