module Mutations
  class CreatePhoto < BaseMutation
    field :photo, Types::PhotoType, null: false

    argument :title, String, required: true
    argument :description, String, required: true

    def resolve(params)
      photo = Photo.new(title: params[:title], description: params[:description])
      if photo.save
        {
          photo: photo,
        }
      else
        {
          photo: {errors: photo.errors},
          id: nil
        }
      end
    end
  end
end
