module Mutations
  class UpdatePhoto < BaseMutation
    field :photo, Types::PhotoType, null: false

    argument :id, ID, required: true
    argument :title, String, required: true
    argument :description, String, required: true

    def resolve(params)
      photo = Photo.find(params[:id])
      if photo.update(title: params[:title], description: params[:description])
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
