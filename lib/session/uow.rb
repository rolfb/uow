module Session
  class Uow < ::Uow

    def insert_command
      Session::Command::Insert
    end

    def delete_command
      Session::Command::Delete
    end

  end
end
