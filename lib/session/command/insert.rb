module Session
  module Command
    class Insert < Uow::Command::Insert
      include Session::Command

      def depends_on?(other)
        super || parent?(other)
      end

    end
  end
end
