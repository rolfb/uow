class Uow
  class Command
    class Insert < Command

      def prepare
        mapper.prepare_for_insert(object)
        self
      end

      def execute
        mapper.insert(object)
      end

      def depends_on?(other)
        other.kind_of?(Update) || other.kind_of?(Delete)
      end

    end
  end
end
