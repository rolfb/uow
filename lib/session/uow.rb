module Session
  class Uow < ::Uow

    def insert_command
      Session::Command::Insert
    end

  end
end
