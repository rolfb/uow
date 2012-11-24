class Uow
  class Command
    class Update < Command

      def execute
        @mapper.update(@object)
      end

      def depends_on?(other)
        other.kind_of?(Delete)
      end

    end
  end
end
