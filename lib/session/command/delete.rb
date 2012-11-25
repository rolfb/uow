module Session
  module Command
    class Delete < Uow::Command::Delete
      include Session::Command

      def depends_on?(other)
        super || other.child?(self)
      end

    end
  end
end
