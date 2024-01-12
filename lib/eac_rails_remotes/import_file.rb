# frozen_string_literal: true

module EacRailsRemotes
  class ImportFile
    def initialize(file)
      @file = file
    end

    def perform
      @counter = Counter.new
      YAML.load_file(@file).each do |r|
        @counter.add_found(r[:source], r[:entity])
        ::EacRailsRemotes::Instance.import(r)
      end
      @counter.show_counts
    end

    private

    def init_counts
      @initial_counts = current_counts
      @counts = @initial_counts.keys.index_with { |_k| 0 }
    end

    class Counter
      def initialize
        @initial_counts = current_counts
        @counts = ActiveSupport::HashWithIndifferentAccess.new
      end

      def add_found(source, entity)
        @counts[entity_to_s(source, entity)] ||= 0
        @counts[entity_to_s(source, entity)] += 1
      end

      def show_counts
        Rails.logger.info('Counts')
        counts_to_show.each do |l, es|
          Rails.logger.info("  * #{l}:")
          es.each do |e, c|
            Rails.logger.info("    * #{e}: #{c}")
          end
        end
      end

      private

      def counts_to_show
        {
          'Initial' => initial_counts,
          'Found' => found_counts,
          'New' => new_counts,
          'Final' => current_counts
        }
      end

      def entity_to_s(source, entity = nil)
        if source.is_a?(::EacRailsRemotes::Instance)
          entity = source.entity
          source = source.source
        elsif source.is_a?(Hash)
          entity = source[:entity]
          source = source[:source]
        end
        "#{source}|#{entity}"
      end

      def entity_to_h(entity)
        if entity.is_a?(String)
          m = /\A([^\|]+)\|([^\|]+)\z/.match(entity)
          return { source: m[1], entity: m[2] } if m

          raise "Entity pattern no matched: \"#{entity}\""
        elsif entity.is_a?(::EacRailsRemotes::Instance)
          return { source: entity.source, entity: entity.entity }
        elsif entity.is_a?(Hash)
          return entity
        end
        raise "Entity class not mapped: #{entity}|#{entity.class}"
      end

      def initial_counts
        Hash[@counts.keys.map { |e, _c| [e, initial_count(e)] }]
      end

      def found_counts
        @counts
      end

      def new_counts
        @counts.keys.index_with { |e| current_count(e) - initial_count(e) }
      end

      def initial_count(entity)
        @initial_counts[entity_to_s(entity)] ||= 0
        @initial_counts[entity_to_s(entity)]
      end

      def current_counts
        r = ActiveSupport::HashWithIndifferentAccess.new
        current_entities.each do |e|
          r[entity_to_s(e)] = current_count(e)
        end
        r
      end

      def current_count(entity)
        entity = entity_to_h(entity)
        ::EacRailsRemotes::Instance.where(source: entity[:source], entity: entity[:entity]).count
      end

      def current_entities
        ::EacRailsRemotes::Instance.select(:source, :entity).distinct
      end
    end
  end
end
