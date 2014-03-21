module Sequenced
  class Generator
    attr_reader :record, :scope, :column, :start_at, :skip, :generator_model, :generator_column

    def initialize(record, options = {})
      @record = record
      @scope = options[:scope]
      @column = (options[:column] || :sequential_id).to_sym
      @start_at = options[:start_at] || 1
      @skip = options[:skip]
      @generator_model = options[:generator_model]
      @generator_column = (options[:generator_column] || :account_id).to_sym
    end

    def set
      record.send(:"#{column}=", next_id) unless id_set? || skip?
    end

    def id_set?
      !record.send(column).nil?
    end

    def skip?
      skip && skip.call(record)
    end

    def next_id
      if @generator_model
        generator = find_generator
        generator.sequential_id += 1
        generator.save
        generator.sequential_id
      else
        next_id_in_sequence.tap do |id|
          id += 1 until unique?(id)
        end
      end
    end

    def next_id_in_sequence
      start_at = self.start_at.respond_to?(:call) ? self.start_at.call(record) : self.start_at
      return start_at unless last_record = find_last_record
      max(last_record.send(column) + 1, start_at)
    end

    def unique?(id)
      build_scope(*scope) do
        rel = base_relation
        rel = rel.where("NOT id = ?", record.id) if record.persisted?
        rel.where(column => id)
      end.count == 0
    end

  private

    def base_relation
      record.class.base_class.unscoped
    end

    def find_last_record
      build_scope(*scope) do
        base_relation.
        where("#{column.to_s} IS NOT NULL").
        order("#{column.to_s} DESC")
      end.first
    end

    def build_scope(*columns)
      rel = yield
      columns.each { |c| rel = rel.where(c => record.send(c.to_sym)) }
      rel
    end

    def max(*values)
      values.to_a.max
    end

    def find_generator
      generator = @generator_model.where("#{@generator_column} = #{record.send(@generator_column)}").lock(true).first
      if generator.nil?
        generator = @generator_model.new
        generator.send("#{@generator_column}=", record.send(@generator_column))
        generator.sequential_id = 0
        generator.save
        generator.lock!
      end
      generator
    end

  end
end