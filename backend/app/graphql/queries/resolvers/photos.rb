module Queries
  module Resolvers
    class Photos < GraphQL::Schema::Resolver
      type [Types::PhotoType], null: false
      description "Photoの一覧取得"

      def resolve
        ::Photo.all
      end
    end

    class Photo < GraphQL::Schema::Resolver
      type Types::PhotoType, null: false
      description "特定Photoの取得"

      argument :id, Integer, required: true, description: "PhotoのID"

      def resolve(params)
        # ::Photoとしているのは、Queries::Resolvers::Photoとして呼ばれるのを防ぐ為
        ::Photo.find(params[:id])
      end
    end
  end
end
