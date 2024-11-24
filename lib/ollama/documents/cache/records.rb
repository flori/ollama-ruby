module Ollama::Documents::Cache::Records
  class Record < JSON::GenericObject
    def initialize(*a)
      super
      self.text ||= ''
      self.norm ||= 0.0
    end

    def to_s
      my_tags = tags_set
      my_tags.empty? or my_tags = " #{my_tags}"
      "#<#{self.class} #{text.inspect}#{my_tags} #{similarity || 'n/a'}>"
    end

    def tags_set
      Ollama::Utils::Tags.new(tags, source:)
    end

    def ==(other)
      text == other.text
    end

    alias inspect to_s
  end

  module RedisFullEach
    def full_each(&block)
      redis.scan_each(match: [ Ollama::Documents, ?* ] * ?-) do |key|
        value = redis.get(key) or next
        value = JSON(value, object_class: Ollama::Documents::Record)
        block.(key, value)
      end
    end
  end

  module FindRecords
    def find_records(needle, tags: nil, max_records: nil)
      tags = Ollama::Utils::Tags.new(Array(tags)).to_a
      records = self
      if tags.present?
        records = records.select { |_key, record| (tags & record.tags).size >= 1 }
      end
      needle_norm = norm(needle)
      records     = records.sort_by { |key, record|
        record.key        = key
        record.similarity = cosine_similarity(
          a: needle,
          b: record.embedding,
          a_norm: needle_norm,
          b_norm: record.norm,
        )
      }
      records.transpose.last&.reverse.to_a
    end
  end

  module Tags
    def clear(tags: nil)
      tags = Ollama::Utils::Tags.new(tags).to_a
      if tags.present?
        if respond_to?(:clear_for_tags)
          clear_for_tags(tags)
        else
          each do |key, record|
            if (tags & record.tags.to_a).size >= 1
              delete(unpre(key))
            end
          end
        end
      else
        super()
      end
    end

    def tags
      if defined? super
        super
      else
        each_with_object(Ollama::Utils::Tags.new) do |(_, record), t|
          record.tags.each do |tag|
            t.add(tag, source: record.source)
          end
        end
      end
    end
  end
end
