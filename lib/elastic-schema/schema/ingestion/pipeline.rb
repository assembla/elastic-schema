module ElasticSchema::Schema::Ingestion
  class Pipeline
    attr_reader :name

    @@pipelines = {}

    def initialize(&block)
      @processors = []

      instance_eval(&block)

      @@pipelines[@name.to_s] = self
    end

    def processor(processor)
      @processors << processor
    end

    def name(name)
      @name = name
    end

    def description(description)
      @description = description
    end

    def to_hash
      {
        description: @description,
        processors: @processors
      }
    end

    def self.pipelines
      @@pipelines
    end
  end
end
