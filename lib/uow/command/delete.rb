class Uow
  class Command
    class Delete < Command

      def execute
        @mapper.delete(@object)
      end

      def depends_on?(other)
        false
      end

    end
  end
end
