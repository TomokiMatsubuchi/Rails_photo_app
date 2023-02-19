module Queries
  module Resolvers
    class Users < GraphQL::Schema::Resolver
      type [Types::UserType], null: false
      description "Userの一覧取得"

      def resolve
        ::User.all
      end
    end

    class User < GraphQL::Schema::Resolver
      type Types::UserType, null: false
      description "特定Userの取得"

      argument :id, Integer, required: true, description: "UserのID"

      def resolve(params)
        # ::Userとしているのは、Queries::Resolvers::Userとして呼ばれるのを防ぐ為
        ::User.find(params[:id])
      end
    end
  end
end