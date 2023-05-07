module Mutations
  class DeletePhoto < BaseMutation
    field :photo, Types::PhotoType, null: false

    argument :id, ID, required: true

    def resolve(params)
      photo = Photo.find(params[:id])
      if photo.delete
        {
          photo: photo
        }
      else
        {
          photo: {errors: photo.errors}
        }
      end
    end
  end
end
