module Mutations
  class CreateUser < BaseMutation
    field :user, Types::UserType, null: false

    argument :name, String, required: true

    def resolve(params)
      user = User.new(name: params[:name])
      if user.save
        {
          user: user
        }
      else
        {
          user: {errors: user.errors}
        }
      end
    end
  end
end
