module Session
  module Command
    class Update < Uow::Command::Update
      include Session::Command

      def depends_on?(other)
        false
      end

    end
  end
end
