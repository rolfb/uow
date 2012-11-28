class Uow
  class Command
    class Delete < Command

      def execute
        @mapper.delete(@object)
      end

    end
  end
end
