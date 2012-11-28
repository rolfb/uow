module Session
  module Command
    class Update < Uow::Command::Update
      include Session::Command

    end
  end
end
