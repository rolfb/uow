class Uow
  class Command
    class Delete < Command

      def prepare
        mapper.prepare_for_delete(object)
        self
      end

      def execute
        mapper.delete(object)
      end

    end
  end
end
