module Session
  class Uow < ::Uow

    def insert_command
      Session::Command::Insert
    end

    def update_command
      Session::Command::Update
    end

    def delete_command
      Session::Command::Delete
    end

  end
end
