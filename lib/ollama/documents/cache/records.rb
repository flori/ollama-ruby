module Ollama::Documents::Cache::Records
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
      tags and tags = Ollama::Utils::Tags.new(tags).to_a
      records = self
      if tags
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
      if tags
        tags = Ollama::Utils::Tags.new(Array(tags)).to_a
        each do |key, record|
          if (tags & record.tags.to_a).size >= 1
            delete(unpre(key))
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
